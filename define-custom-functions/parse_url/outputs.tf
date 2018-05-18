output "result" {
  value = {
    scheme = "${local.scheme}"
    host   = "${local.host}"
    port   = "${local.port}"
    path   = "${local.path}"
    query  = "${local.query}"
    hash   = "${local.hash}"
  }
}
