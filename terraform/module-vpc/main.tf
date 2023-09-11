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
    VpcBlock             = var.vpccidr
    PublicSubnet01Block  = var.publiccidr01
    PublicSubnet02Block  = var.publiccidr02
    PrivateSubnet01Block = var.privatecidr01
    PrivateSubnet02Block = var.privatecidr02
  }

  template_url = "https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml"
  tags = {
    "environment"                   = "dev"
    "kubernetes.io/cluster/phantom" = "shared"
  }
}

module "eks-creation" {
  source = "./module-eks"
  depends_on = [aws_cloudformation_stack.eks-vpc]
}


