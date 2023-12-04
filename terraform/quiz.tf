resource "kubernetes_namespace" "quiz-namespace" {
  metadata {
    annotations = {
      name = "jessitron-says"
    }

    labels = {
      managedBy = "jessitron"
    }

    name = "quiz"
  }
}
