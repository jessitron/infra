locals {
  name  = "httpbin"
  image = "kennethreitz/httpbin:latest"
  port  = 80
}

resource "kubernetes_deployment_v1" "main" {
  metadata {
    name = local.name
    labels = {
      app = local.name
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = local.name
      }
    }

    template {
      metadata {
        labels = {
          app = local.name
        }
      }

      spec {
        container {
          image = local.image
          name  = local.name

          port {
            container_port = local.port
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "main" {
  depends_on = [
    kubernetes_deployment_v1.main,
  ]

  metadata {
    name = "httpbin"
  }

  spec {
    type = "NodePort"

    port {
      protocol    = "TCP"
      port        = local.port
      target_port = local.port
    }

    selector = {
      app = local.name
    }
  }
}

resource "kubernetes_ingress_v1" "main" {
  depends_on = [
    kubernetes_service_v1.main,
  ]

  metadata {
    name = local.name

    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {
    default_backend {
      service {
        name = local.name
        port {
          number = local.port
        }
      }
    }
  }

  wait_for_load_balancer = true
}

output "ingress_host" {
  value = kubernetes_ingress_v1.main.status[0].load_balancer[0].ingress[0].hostname
}
