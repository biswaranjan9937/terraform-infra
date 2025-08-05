environments = {
  default = {
    # Global variables
    cluster_name = "poc-cluster"
    env          = "default"
    region       = "ap-south-1"
    # vpc_id                         = "vpc-086438378e671ee51"
    # vpc_cidr                       = "10.0.0.0/16"
    # public_subnet_ids              = ["subnet-0f0754375ebbb1581", "subnet-0a5690b68629d21a4"]
    cluster_version                = "1.33"
    cluster_endpoint_public_access = true
    # ecr_names                      = ["codedevops"]

    # EKS variables
    eks_managed_node_groups = {
      poc-eks-ng = {
        min_size       = 1
        max_size       = 2
        desired_size   = 1
        instance_types = ["t3.medium"]
        capacity_type  = "ON_DEMAND"
        disk_size      = 20
        ebs_optimized  = true
        iam_role_additional_policies = {
          ssm_access        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
          cloudwatch_access = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
          service_role_ssm  = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
          default_policy    = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
        }
      }
    }
    cluster_security_group_additional_rules = {}

    # EKS Cluster Logging
    cluster_enabled_log_types = ["audit"]
    eks_access_entries = {
      viewer = {
        user_arn = []
      }
      admin = {
        user_arn = ["arn:aws:iam::663880399834:user/Biswa"]
      }
    }
    # EKS Addons variables 
    coredns_config = {
      replicaCount = 1
    }
  }

}
