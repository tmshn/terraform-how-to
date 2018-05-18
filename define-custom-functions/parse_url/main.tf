locals {
  url_regex = "/^(?:(?P<scheme>\\w+):\\/\\/)?(?P<host>[^:\\/]+)(?::(?P<port>\\d+))?(?P<path>[^\\?#]*)(?:\\?(?P<query>[^#]*))?(?:#(?P<hash>.*))?$/"
}

locals {
  scheme = "${replace(var.url, local.url_regex, "$scheme")}"
  host   = "${replace(var.url, local.url_regex, "$host")}"
  port   = "${replace(var.url, local.url_regex, "$port")}"
  path   = "${replace(var.url, local.url_regex, "$path")}"
  query  = "${replace(var.url, local.url_regex, "$query")}"
  hash   = "${replace(var.url, local.url_regex, "$hash")}"
}
