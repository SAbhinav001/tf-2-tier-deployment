#VPC CREATION
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkis-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
  public_subnets  = var.pub_subnets_cidr

  enable_dns_hostnames = true
  map_public_ip_on_launch = true

  tags = {
    Name = "jenkins-vpc"
    Terraform = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "jenkins-subnet"
  }
} 

#SG FOR JENKINS SERVER

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-sg"
  description = "security grp for jenkins server"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "http"
      cidr_blocks = "0.0.0.0/0"
    },
   {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "jenkins-sg"
  }
}

#EC2

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-server"
  instance_type          = var.instance_type
  key_name               = "server"
  monitoring             = true
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  user_data = file("jenkins-install.sh")
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}