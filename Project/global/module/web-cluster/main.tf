provider "aws" {
    region = "ap-northeast-2"
}

#------------vpc resource-----------
#vpc
resource "aws_vpc" "global-vpc"{
    cidr_block = var.global_vpc

    tags = {
        Name = "global-vpc"
    }
}

#IGW
resource "aws_internet_gateway" "global-igw"{
    vpc_id = aws_vpc.global-vpc.id
    tags = {
        Name = "global-igw"
    }
}

#Nat GW
resource "aws_eip" "global-eip"{
    vpc = true
    tags = {
        Name = "global-eip"
    }
}

resource "aws_nat_gateway" "global-ngw"{
    allocation_id = aws_eip.global-eip.id
    subnet_id   = aws_subnet.global-public-subnet-a.id
    tags = {
        Name = "global-ngw"
    }
}

#Public subnet
resource "aws_subnet" "global-public-subnet-a"{
    vpc_id  = aws_vpc.global-vpc.id
    cidr_block  = var.public_subnet_a
    availability_zone = var.az_a
    map_public_ip_on_launch = true

    tags = {
        Name = "global-public-subnet-a"
    }

}
resource "aws_subnet" "global-public-subnet-c"{
    vpc_id  = aws_vpc.global-vpc.id
    cidr_block  = var.public_subnet_c
    availability_zone = var.az_c
    map_public_ip_on_launch = true

    tags = {
        Name = "global-public-subnet-c"
    }

}

#private Subnet-web
resource "aws_subnet" "global-private-subnet-a-web"{
    vpc_id  = aws_vpc.global-vpc.id
    cidr_block  = var.private_subnet_a_web
    availability_zone = var.az_a

    tags = {
        Name = "global-private-subnet-a-web"
    }

}
resource "aws_subnet" "global-private-subnet-c-web"{
    vpc_id  = aws_vpc.global-vpc.id
    cidr_block  = var.private_subnet_c_web
    availability_zone = var.az_c

    tags = {
        Name = "global-private-subnet-c-web"
    }

}

#private Subnet-was
resource "aws_subnet" "global-private-subnet-a-was"{
    vpc_id  = aws_vpc.global-vpc.id
    cidr_block  = var.private_subnet_a_was
    availability_zone = var.az_a

    tags = {
        Name = "global-private-subnet-a-was"
    }

}
resource "aws_subnet" "global-private-subnet-c-was"{
    vpc_id  = aws_vpc.global-vpc.id
    cidr_block  = var.private_subnet_c_was
    availability_zone = var.az_c

    tags = {
        Name = "global-private-subnet-c-was"
    }

}

#private subnet-DB
resource "aws_subnet" "global-private-subnet-a-db"{
    vpc_id  = aws_vpc.global-vpc.id
    cidr_block  = var.private_subnet_a_DB
    availability_zone = var.az_a

    tags = {
        Name = "global-private-subnet-a-db"
    }

}

resource "aws_subnet" "global-private-subnet-c-db"{
    vpc_id  = aws_vpc.global-vpc.id
    cidr_block  = var.private_subnet_c_DB
    availability_zone = var.az_c

    tags = {
        Name = "global-private-subnet-c-db"
    }

}
#Route ,Route table
#Public RT
resource "aws_route_table" "global-public-routetable" {
    vpc_id = aws_vpc.global-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.global-igw.id
    }
    tags = {
        Name = "global-public-routetable"
    }
}

# public subnet -> public route table
resource "aws_route_table_association" "global-public-rta-a"{
    subnet_id = aws_subnet.global-public-subnet-a.id
    route_table_id = aws_route_table.global-public-routetable.id
}

resource "aws_route_table_association" "global-public-rta-c"{
    subnet_id = aws_subnet.global-public-subnet-c.id
    route_table_id = aws_route_table.global-public-routetable.id
}

# private web,was -> nat
resource "aws_route_table" "global-private-routetable-web"{
    vpc_id = aws_vpc.global-vpc.id
    
    tags = {
       Name = "global-private-routetable-web"
   }
}

resource "aws_route" "global-private-route-web"{
    route_table_id = aws_route_table.global-private-routetable-web.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.global-ngw.id
}

resource "aws_route_table" "global-private-routetable-was"{
    vpc_id = aws_vpc.global-vpc.id
    
    tags = {
       Name = "terraform-rt-pri-was"
   }
}

resource "aws_route" "global-private-route-was"{
    route_table_id = aws_route_table.global-private-routetable-was.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.global-ngw.id
}

#db rt
resource "aws_route_table" "global-private-routetable-db"{
    vpc_id = aws_vpc.global-vpc.id
    
    tags = {
       Name = "global-private-routetable-db"
   }
}

resource "aws_route" "global-private-route-db"{
    route_table_id = aws_route_table.global-private-routetable-db.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.global-ngw.id
}

# private subnet -> pirvate route table
resource "aws_route_table_association" "global-private-rta-a-web"{
    subnet_id = aws_subnet.global-private-subnet-a-web.id
    route_table_id = aws_route_table.global-private-routetable-web.id
}

resource "aws_route_table_association" "global-private-rta-c-web"{
    subnet_id = aws_subnet.global-private-subnet-c-web.id
    route_table_id = aws_route_table.global-private-routetable-web.id
}

resource "aws_route_table_association" "global-private-rta-a-was"{
    subnet_id = aws_subnet.global-private-subnet-a-was.id
    route_table_id = aws_route_table.global-private-routetable-was.id
}

resource "aws_route_table_association" "global-private-rta-c-was"{
    subnet_id = aws_subnet.global-private-subnet-c-was.id
    route_table_id = aws_route_table.global-private-routetable-was.id
}

resource "aws_route_table_association" "global-private-rta-a-db"{
    subnet_id = aws_subnet.global-private-subnet-a-db.id
    route_table_id = aws_route_table.global-private-routetable-db.id
}

resource "aws_route_table_association" "global-private-rta-c-db"{
    subnet_id = aws_subnet.global-private-subnet-c-db.id
    route_table_id = aws_route_table.global-private-routetable-db.id
}

#----------------SG resource------------
#public
resource "aws_security_group" "global-public-sg-bastion"{
    name    = "global-public-sg-bastion"
    description = "global-public-sg-bastion"
    vpc_id  = aws_vpc.global-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "global-public-sg-bastion"
  }
}

#private web
resource "aws_security_group" "global-private-sg-web"{
    name    = "global-private-sg-web"
    description = "global-private-sg-web"
    vpc_id  = aws_vpc.global-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.global-public-sg-bastion.id]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "global-private-sg-web"
  }
}

#private was
resource "aws_security_group" "global-private-sg-was"{
    name    = "global-private-sg-was"
    description = "global-private-sg-was"
    vpc_id  = aws_vpc.global-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.global-public-sg-bastion.id]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_a_web,var.private_subnet_c_web]    
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "global-private-sg-was"
  }
}

#DB
resource "aws_security_group" "global-private-sg-db"{
    name    = "global-private-sg-db"
    description = "global-private-sg-db"
    vpc_id  = aws_vpc.global-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
     security_groups = [aws_security_group.global-public-sg-bastion.id]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "global-private-sg-db"
  }
}

#----------------ec2---------------
#public
resource "aws_instance" "global-public-ec2-a"{
  ami = var.ec2_ami
  instance_type = "t2.micro"
  availability_zone = var.az_a
  key_name = "sswoo2022"

  subnet_id = aws_subnet.global-public-subnet-a.id
  vpc_security_group_ids = [
      aws_security_group.global-public-sg-bastion.id
  ]
  tags = {
      Name = "global-public-ec2-a"
  }
}

resource "aws_instance" "global-public-ec2-c"{
  ami = var.ec2_ami
  instance_type = "t2.micro"
  availability_zone = var.az_c
  key_name = "sswoo2022"

  subnet_id = aws_subnet.global-public-subnet-c.id
  vpc_security_group_ids = [
      aws_security_group.global-public-sg-bastion.id
  ]
  tags = {
      Name = "global-public-ec2-c"
  }
}

#web
resource "aws_instance" "global-private-ec2-a-web"{
  ami = var.ec2_ami
  instance_type = "t2.micro"
  availability_zone = var.az_a

  subnet_id = aws_subnet.global-private-subnet-a-web.id
  vpc_security_group_ids = [
      aws_security_group.global-private-sg-web.id
  ]
  tags = {
      Name = "global-private-ec2-a-web"
  }
}

resource "aws_instance" "global-private-ec2-c-web"{
  ami = var.ec2_ami
  instance_type = "t2.micro"
  availability_zone = var.az_c

  subnet_id = aws_subnet.global-private-subnet-c-web.id
  vpc_security_group_ids = [
      aws_security_group.global-private-sg-web.id
  ]
  tags = {
      Name = "global-private-ec2-c-web"
  }
}
#was
resource "aws_instance" "global-private-ec2-a-was"{
  ami = var.ec2_ami
  instance_type = "t2.micro"
  availability_zone = var.az_a

  subnet_id = aws_subnet.global-private-subnet-a-was.id
  vpc_security_group_ids = [
      aws_security_group.global-private-sg-was.id
  ]
  tags = {
      Name = "global-private-ec2-a-was"
  }
}

resource "aws_instance" "global-private-ec2-c-was"{
  ami = var.ec2_ami
  instance_type = "t2.micro"
  availability_zone = var.az_c

  subnet_id = aws_subnet.global-private-subnet-c-was.id
  vpc_security_group_ids = [
      aws_security_group.global-private-sg-was.id
  ]
  tags = {
      Name = "global-private-ec2-c-was"
  }
}

#-----------------DB----------------
resource "aws_db_subnet_group" "global-subnet-group" {
  name        = "db-subnet-group"
  description = "The subnets used for RDS "
  subnet_ids  = ["${aws_subnet.global-private-subnet-a-db.id}", "${aws_subnet.global-private-subnet-c-db.id}"]

  tags = {
    Name = "db-subnet-group"
  }
}

resource "aws_db_instance" "global-master-db" {
  allocated_storage = 50
  max_allocated_storage = 80
  engine = "mysql"
  engine_version = "5.7.22"
  instance_class = "db.t2.micro"
  name = "globalmasterdb"
  username = "admin"
  password = "password"
  db_subnet_group_name = aws_db_subnet_group.global-subnet-group.id
  multi_az = true
  skip_final_snapshot = true
  vpc_security_group_ids = [ 
    aws_security_group.global-private-sg-db.id
   ]
  tags = {
      "name" = "MasterDB"
    }
}

#------------ALB,NLB----------------
# alb
resource "aws_lb" "global-alb-web"{
  name = "global-alb-web"
  internal    = false	
  load_balancer_type = "application"
  security_groups = [aws_security_group.global-alb-sg-web.id]
  subnets     = [aws_subnet.global-public-subnet-a.id, aws_subnet.global-public-subnet-c.id]
  tags = {
    Name = "global-alb-web"
  }
}

# targetgroup
resource "aws_lb_target_group" "global-targetgroup-web"{
  name = "global-targetgroup-web"
  port = "80"
  protocol = "HTTP"
  vpc_id  = aws_vpc.global-vpc.id
  target_type = "instance"
  tags = {
     Name = "global-targetgroup-web"
  }
}

# listner
resource "aws_lb_listener" "global-listner-web"{
  load_balancer_arn = aws_lb.global-alb-web.arn
  port    = "80"
  protocol    = "HTTP"
  default_action{
     type = "forward"
    target_group_arn = aws_lb_target_group.global-targetgroup-web.arn
  }
}

# web attachement
resource "aws_lb_target_group_attachment" "global-attachement-web1"{
    target_group_arn  = aws_lb_target_group.global-targetgroup-web.arn
    target_id = aws_instance.global-private-ec2-a-web.id
    port = 80
}
resource "aws_lb_target_group_attachment" "global-attachement-web2"{
    target_group_arn = aws_lb_target_group.global-targetgroup-web.arn
    target_id = aws_instance.global-private-ec2-c-web.id
    port = 80
}

# alb sg
resource "aws_security_group" "global-alb-sg-web" {
  name = "global-alb-sg-web"
  description = "global-alb-sg-web"
  vpc_id = aws_vpc.global-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
   Name = "global-alb-sg-web"
  }
}

#NLB
resource "aws_lb" "global-nlb-was"{
    name = "global-nlb-was"
    internal = true	
    load_balancer_type = "network"
    subnets = [aws_subnet.global-private-subnet-a-web.id, aws_subnet.global-private-subnet-c-web.id]
    tags = {
        Name = "global-nlb-was"
    }
}

# targetgroup
resource "aws_lb_target_group" "global-targetgroup-was"{
    name = "global-targetgroup-was"
    port = "8080"
    protocol = "TCP"
    vpc_id  = aws_vpc.global-vpc.id
    target_type = "instance"
    tags = {
        Name = "global-targetgroup-was"
    }
}

#listner
resource "aws_lb_listener" "global-nlt-was"{
    load_balancer_arn = aws_lb.global-nlb-was.arn
    port = "8080"
    protocol = "TCP"
    default_action{
      type = "forward"
      target_group_arn = aws_lb_target_group.global-targetgroup-was.arn
    }
}

resource "aws_lb_target_group_attachment" "global-attachement-was1"{
    target_group_arn    = aws_lb_target_group.global-targetgroup-was.arn
    target_id   = aws_instance.global-private-ec2-a-was.id
    port    = 8080
}
resource "aws_lb_target_group_attachment" "global-attachement-was2"{
    target_group_arn    = aws_lb_target_group.global-targetgroup-was.arn
    target_id   = aws_instance.global-private-ec2-c-was.id
    port    = 8080
}

#--------------ASG--------------------
#web시작구성
resource "aws_launch_configuration" "web_launch" {
  image_id        = var.launch_web
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.global-private-sg-web.id]

  lifecycle {
    create_before_destroy = true
  }
}

#was시작구성
resource "aws_launch_configuration" "was_launch" {
  image_id        = var.launch_was
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.global-private-sg-was.id]

  lifecycle {
    create_before_destroy = true
  }
}

#web-autoscailing
resource "aws_autoscaling_group" "web_asg" {
  launch_configuration = aws_launch_configuration.web_launch.name
  vpc_zone_identifier  = [ aws_subnet.global-private-subnet-a-web.id, aws_subnet.global-private-subnet-c-web.id ]
  target_group_arns = [aws_lb_target_group.global-targetgroup-web.arn]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key                 = "Name"
    value               = "global-asg-web"
    propagate_at_launch = true
  }
}

#was-autoscailing
resource "aws_autoscaling_group" "was_asg" {
  launch_configuration = aws_launch_configuration.was_launch.name
  vpc_zone_identifier  = [ aws_subnet.global-private-subnet-a-was.id, aws_subnet.global-private-subnet-c-was.id ]
  target_group_arns = [aws_lb_target_group.global-targetgroup-was.arn]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key                 = "Name"
    value               = "global-asg-was"
    propagate_at_launch = true
  }
}