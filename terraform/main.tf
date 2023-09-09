/*provider "aws" {
    region = "ap-south-1"
    access_key = "**************"
    secret_key = "**************"
}
*/
#Create VPC and subnet using cloudformation template
resource "aws_cloudformation_stack" "eks-vpc" {
    name = "eksvpc"
    parameters = {
      VpcBlock = var.vpccidr
      PublicSubnet01Block = var.publiccidr01
      PublicSubnet02Block = var.publiccidr02
      PrivateSubnet01Block = var.privatecidr01
      PrivateSubnet02Block = var.privatecidr02
    }

    template_url = "https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml"
}

data "aws_vpc" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}




/*
#use module for eks cluster creation
module "eks" "myeks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "demo-cluster"
  cluster_version = "1.27"

  cluster_endpoint_public_access  = true
  vpc_id                   = "${aws_cloudformation_stack.eks-vpc.id}"
  subnet_ids               = ["${aws_cloudformation_stack.eks-vpc.SubnetIds[0]
  }", "subnet-bcde012a", "subnet-fghi345a"]
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}  
*/