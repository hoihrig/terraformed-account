data "aws_subnet" "selected" {
  id = "${data.terraform_remote_state.networking.public_subnet_ids.1}"
}

resource "aws_security_group" "http" {
  name_prefix = "http"
  description = "terraform example"
  vpc_id      = "${data.terraform_remote_state.networking.vpc_id}"


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
  count = 2
  subnet_id         = "${data.terraform_remote_state.networking.public_subnet_ids.1}"
  availability_zone = "${data.aws_subnet.selected.availability_zone}"
  ami               = "${data.aws_ami.ubuntu.id}"
  instance_type     = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.http.id}"]

  user_data = "${file("scripts/userdata.tpl")}"

  tags {
  	Name = "web"
  }

}


resource "aws_elb" "web" {
  name = "web-userdata"

  subnets = ["${data.terraform_remote_state.networking.public_subnet_ids.1}"]

  security_groups = ["${aws_security_group.http.id}"]

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
