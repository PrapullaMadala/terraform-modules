# Create security group for ssh, web, nagios etc
resource "aws_security_group" "security_group" {
  name   = "nagios_security_group"
  vpc_id = "${aws_vpc.my_vpc.id}"
}

resource "aws_security_group_rule" "allow-ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.security_group.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow-outbound" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.security_group.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow-http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.security_group.id}"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow-https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.security_group.id}"
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "allow-egress-http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.security_group.id}"
  to_port           = 80
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow-egress-https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.security_group.id}"
  to_port           = 443
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}