data "aws_subnet" "selected" {
  id = "${data.terraform_remote_state.networking.public_subnet_ids.0}"
}

resource "aws_security_group" "http_and_ssh" {
  name_prefix = "http-and-ssh"
  description = "terraform example"
  vpc_id      = "${data.terraform_remote_state.networking.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
  tags {
    Name = "web"
  }

  count = 2

  subnet_id         = "${data.terraform_remote_state.networking.public_subnet_ids.0}"
  availability_zone = "${data.aws_subnet.selected.availability_zone}"
  ami               = "${data.aws_ami.ubuntu.id}"
  instance_type     = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.http_and_ssh.id}"]

  connection {
    user        = "ubuntu"
    private_key = "${file("/Users/hoih/.ssh/id_rsa")}"
  }

  key_name = "${data.terraform_remote_state.global.hoih_keypair_name}"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
      "echo \"<h1>${self.public_dns}</h1>\" | sudo tee /var/www/html/index.html",
      "echo \"<h2>${self.public_ip}</h2>\"  | sudo tee -a /var/www/html/index.html",
    ]
  }
}

resource "aws_elb" "web" {
  name = "web-remote"

  subnets = ["${data.terraform_remote_state.networking.public_subnet_ids.0}"]

  security_groups = ["${aws_security_group.http_and_ssh.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances = ["${aws_instance.webserver.*.id}"]

  tags {
    Name = "training"
  }
}
