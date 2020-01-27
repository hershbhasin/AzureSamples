provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}
variable "subnet-1" {
  type = string
  default = "subnet-027d9374b30fc21c7"
}

variable "subnet-2" {
   type = string
  default = "subnet-0cce5a5fdd0565c6a"
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${var.subnet-1}", "${var.subnet-2}"]

  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "sqlserver-ex"
  engine_version       = "14.00.1000.169.v1"
  instance_class       = "db.t2.micro"
  name                 = null
  username             = "foo"
  password             = "foobarbaz"
  db_subnet_group_name = aws_db_subnet_group.default.name
  
}