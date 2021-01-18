resource "kubernetes_secret" "example" {
  metadata {
    name = "example-test"
  }

  data = {
    username = "admin"
    password = "xxxxx"
  }

  type = "kubernetes.io/basic-auth"
}