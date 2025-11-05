resource "helm_release" "spring_petclinic" {
  name = var.release_name
  chart = var.chart_name
  namespace = var.namespace
  values = [for file in var.values : file("${file}")]
  disable_openapi_validation = true
}