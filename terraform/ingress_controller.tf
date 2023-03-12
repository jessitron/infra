module "alb-ingress-controller" {
  source  = "iplabs/alb-ingress-controller/kubernetes"
  version = "3.4.0"
  # insert the 3 required variables here

  aws_region_name = var.region
  k8s_cluster_type = "eks"
  aws_alb_ingress_controller_version = "2.4.7"
  k8s_cluster_name = local.cluster_name
  aws_tags = {
    wtf = "ingress controller please"
  }
  k8s_pod_annotations = {
    wtf = "ingress controller please"
  }
}
