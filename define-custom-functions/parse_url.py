#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Small script to parse URL (intended to use from Terraform)."""

import json
import re
import sys


URL_REGEX = re.compile('^(?:(?P<scheme>\\w+):\\/\\/)?(?P<host>[^:\\/]+)(?::(?P<port>\\d+))?(?P<path>[^\\?#]*)(?:\\?(?P<query>[^#]*))?(?:#(?P<hash>.*))?$')


def parse_url(url):
    """Parse URL and returns its parts as dict."""
    try:
        return URL_REGEX.search(url).groupdict(default='')
    except AttributeError:  # If regex did not match
        raise ValueError('invalid url')


def main():
    """Read URL from stdin, parse it, and write result into stdout."""
    input_data = json.load(sys.stdin)

    url = input_data['url']
    result = parse_url(url)

    json.dump(result, sys.stdout)


if __name__ == '__main__':
    main()
