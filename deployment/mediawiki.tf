resource "helm_release" "mediawiki" {
  repository = "rala/mediawiki"
  name       = "my-local-chart"
  chart      = "./helm-chart/mediawiki"
}