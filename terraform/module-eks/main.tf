
data "aws_vpc" "vpc" {
  tags = {
    environment = "dev"
  }
}

output "vpcs" {
  value = data.aws_vpc.vpc.id
}

data "aws_subnets" "getsubnet" {
  tags = {
    environment = "dev"
  }
}

#use module for eks cluster creation
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "phantom"
  cluster_version = "1.27"
#  for_each        = toset(data.aws_subnets.getsubnet.ids)

  cluster_endpoint_public_access = true
  vpc_id                         = data.aws_vpc.vpc.id
#  subnet_ids                     = [each.value]
  create_cloudwatch_log_group = false

  eks_managed_node_group_defaults = {
    eks_managed_node_groups = {
      nodegroup-1 = {
        min_size     = 1
        max_size     = 10
        desired_size = 1

        instance_types = ["t2.micro"]
        capacity_type  = "SPOT"
      }
    }
    tags = {
      environment = "dev"
      Terraform   = "true"
    }
  }
}