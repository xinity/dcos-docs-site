---
layout: layout.pug
navigationTitle:  Command-Line Interface (CLI) Reference
title: Edge-LB CLI Reference
menuWeight: 81
excerpt: Provides usage and reference information for Edge-LB commands

enterprise: false
---

You can use the Edge-LB command-line interface (CLI) commands and subcommands to configure and manage your Edge-LB load balancer instances from a shell terminal or programmatically.

# Usage

```bash
dcos edgelb [<flags>] [OPTIONS] [<args> ...]
```

# Options

| Name, shorthand       | Description |
|----------|-------------|
| `--help, h`   | Display usage. |
| `--verbose`   | Enable additional logging of requests and responses. |
| `--name="<name>"`   | Name of the service instance to query. |
