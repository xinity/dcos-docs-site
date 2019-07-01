---
layout: layout.pug
navigationTitle: Failed Installations
title: Failed Installations
menuWeight: 4
excerpt: 
enterprise: false


---

This document covers troubleshooting of Kubernetes clusters, with an emphasis on items specific to clusters deployed with `konvoy`.

For general [Kubernetes][0] troubleshooting tips, see the [Kubernetes troubleshooting documentation][1].

## Provisioning Failures

On occasion, failures can occur during installation (e.g. `konvoy up` or `konvoy deploy`).

The most common reason for provisioning failures is errors communicating with the API for the underlying *provider* (e.g. something fails during a call to the AWS API).

Failures in calls to provision infrastructure via the provider API tend to be visible as [Terraform][2] errors (under the hood, `terraform` is used as part of the provisioning process for **konvoy** clusters).
When problems occur, verbosity can be added to the output with `--verbose`:

```bash
konvoy up --verbose
```

### Expired Credentials

A common failure is expired or invalid credentials for the cloud provider, which would manifest itself in this way:

```bash
$ ./konvoy up

An error occurred (ExpiredToken) when calling the GetCallerIdentity operation: The security token included in the request is expired
Please refresh your AWS credentials; the AWS API could not be reached with your current credentials.
```

In this case the error message is explaining that the credentials in `~/.aws/credentials` and any provided `AWS_PROFILE` therein are expired and need to be renewed.

This scenario is specific to security credentials on AWS, for more help with the problem demonstrated above specifically, see the [AWS Temporary Credentials Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp.html) and the [requirements documentation](../install-uninstall-upgrade/basics_aws.md#prerequisites).

[0]:https://kubernetes.io
[1]:https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/
[2]:https://terraform.io
