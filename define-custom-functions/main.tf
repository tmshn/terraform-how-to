variable "url" {
  type        = "string"
  description = "URL to parse."
  default     = "https://blog.example.com/articles?category=bigdata"
}

data "external" "url_parts" {
  program = ["python", "parse_url.py"]

  # input to the program
  query = {
    url = "${var.url}"
  }

  # result = (...result of the program...)
}

module "url_parts" {
  source = "./parse_url"
  url    = "${var.url}"
}
