module "vpc" {
  source      = "./modules/vpc"
  project     = var.project
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  azs         = var.azs
}

module "iam" {
  source       = "./modules/iam"
  project = "waza-app"
}
module "eks" {
  source = "./modules/eks"
  cluster_name       = var.cluster_name
  cluster_version    = "1.29"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  project          = var.project
  environment           = var.environment
  cluster_iam_role_arn  = module.iam.eks_cluster_role_arn
  iam_dependency        = module.iam
  node_role_arn        = module.iam.eks_node_role_arn
  # ssh_key_name = var.ssh_key_name
}
