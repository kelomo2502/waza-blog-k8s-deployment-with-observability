resource "aws_eks_cluster" "this" {
  name     = "${var.project}-eks"
  role_arn = var.cluster_iam_role_arn

  version = var.cluster_version

  vpc_config {
    subnet_ids = var.private_subnet_ids
    security_group_ids = [aws_security_group.eks_cluster_sg.id]

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name        = "${var.project}-eks"
    Environment = var.environment
  }

  depends_on = [
    var.iam_dependency
  ]
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids
  remote_access {
    ec2_ssh_key = var.ssh_key_name != null ? var.ssh_key_name : null
    source_security_group_ids = [aws_security_group.eks_node_sg.id]
  }

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types

  ami_type = "AL2023_x86_64_STANDARD"
  disk_size      = 20

  labels = {
    Environment = var.environment
    Project     = var.project
  }

  depends_on = [aws_eks_cluster.this]
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.project}-eks-cluster-sg"
  description = "EKS cluster security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all node traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-eks-cluster-sg"
  }
}

resource "aws_security_group" "eks_node_sg" {
  name        = "${var.project}-eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow nodes to communicate with each other"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = "Allow pods to communicate with the cluster API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-eks-node-sg"
  }
}
