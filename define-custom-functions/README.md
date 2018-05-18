# How to define custom functions in Terraform

*This article is confirmed against following version of Terraform.*

```bash
$ terraform -v
Terraform v0.11.7
```

---

As you may already suffered from, Terraform provides **no** straight-forward way of defining custom functions.

Here, I will introduce you three ways to that; two of which coming with examples:

### 1. Call an external program from "external data source"

["External data source"](https://www.terraform.io/docs/providers/external/data_source.html) is a way to call external program and use its output as [data source](https://www.terraform.io/docs/configuration/data-sources.html).

```hcl
# (...variable definition omitted...)

data "external" "url_parts" {
  program = ["python", "parse_url.py"]

  # input to the program
  query = {
    url = "${var.url}"
  }
  
  # result = (...result of the program...)
}
```

```bash
$ terraform apply -var url='tcp://redis.example.com:6379'
$ echo 'data.external.url_parts.result' | terraform console
{
  "hash" = ""
  "host" = "redis.example.com"
  "path" = ""
  "port" = "6379"
  "query" = ""
  "scheme" = "tcp"
}
```

See [`main.tf`](main.tf) and [`parse_url.py`](parse_url.py) for working example.

### 2. Write interpolation functions inside a module

[Module](https://www.terraform.io/docs/configuration/modules.html) is a way to encapsule a group of resources and/or interpolations.

```hcl
# (...variable definition omitted...)

module "url_parts" {
  source = "./parse_url"
  url    = "${var.url}"
}
```

```bash
$ echo 'module.url_parts.result' | terraform console
$ echo 'data.external.url_parts.result' | terraform console
{
  "hash" = ""
  "host" = "redis.example.com"
  "path" = ""
  "port" = "6379"
  "query" = ""
  "scheme" = "tcp"
}
```

See [`main.tf`](main.tf) and [`parse_url/`](parse_url/) for working example.

### 3. Implement and compile custom function in Terraform's source

Not detailed here. See the source file if interested.

:octocat: https://github.com/hashicorp/terraform/blob/v0.11.7/config/interpolate_funcs.go

## Pros vs. Cons

|                                 | Call an external program from "external data source"  | Write interpolation functions inside a module   | Implement and compile custom function in Terraform's source |
|:--------------------------------|:------------------------------------------------------|:------------------------------------------------|:------------------------------------------------------------|
| Need extra dependencies?        | :broken_heart: requires runtime of the program        | :white_check_mark: only Terraform               | :white_check_mark: only (custom compiled) Terraform         |
| What you can do?                | :white_check_mark: anything                           | :broken_heart: only what interpolations can do  | :white_check_mark: anything                                 |
| Need to write block in config?  | :broken_heart: yes                                    | :broken_heart: yes                              | :white_check_mark: no (just call from inline)               |
| Need to compile from source?    | :white_check_mark: no                                 | :white_check_mark: no                           | :broken_heart: yes                                          |
