---
layout: layout.pug
navigationTitle: Security
title: Security Basics
menuWeight: 1
excerpt: 
enterprise: false


---

[Kubernetes](https://kubernetes.io) clusters deployed with `konvoy` rely on [role-based access controls (RBAC)](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) to provide the rules that govern the specific API actions different sets of users are allowed to perform. Roles enable you to grant or deny permissions for different security groups and the users who are assigned to each of those roles.

The topics in this section cover aspects of security that are specific to a **konvoy** cluster.

If you are not familiar with security for Kubernetes, you should start by reviewing how to [secure a cluster](https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/) in the Kubernetes documentation.

## Add-on security

Security for cluster add-ons is managed through a combination of:
- Component-level **role-based access controls** (RBAC).
- **Namespace** isolation.
- **Secret generators** that create add-on secret keys.

For example, any particular add-on can have its own **namespace**. You can control the permissions for who has access to components in that namespace by defining roles and role-based access control (RBAC) rules. In this way, users must be specifically granted access to the namespace according to their assigned roles before they can work with add-ons or manage add-on resources in that namespace. All users except the cluster administrator (`cluster-admin`) can be explicitly granted access to the specific add-ons they should be allowed to use.

The following **namespaces** are deployed by  default:

* velero - a namespace entirely for [Velero](https://github.com/heptio/velero) and its components.

* kubeaddons - a namespace where add-ons are deployed if they don't specifically need their own namespace.

For add-ons that require authentication, such as **Velero**, credentials are automatically generated. If you have been granted access to an add-on namespace, you can retrieve those credentials through [Kubernetes secrets](https://kubernetes.io/docs/concepts/configuration/secret/) that are deployed into the relevant namespace.

For example, the Velero [Minio](https://github.com/minio/minio) backend requires [Amazon S3 credentials](https://github.com/minio/minio/blob/master/docs/gateway/s3.md) to access the storage backend for Velero backups. You can retrieve the credentials for accessing the storage backend by running the following command:

```bash
$ kubectl -n velero get secrets
```

This command returns information similar to the following:
```
NAME                        TYPE                                  DATA   AGE
default-token-jg8w5         kubernetes.io/service-account-token   3      52m
minio-credentials           Opaque                                2      50m
velero-restic-credentials   Opaque                                1      50m
velero-token-jnpct          kubernetes.io/service-account-token   3      50m
```

You can retrieve the password from the data section of the secret by running the following command:

```bash
$ kubectl -n velero get secret minio-credentials --template '{{.data.password}}' | base64 -d
```

Replace `base64 -d` with `base64 -D` if you are running this command on macOS. This command returns the password to standard output.

## Network security

**Konvoy** clusters have external networking components that rely on the infrastructure provided for the instances (for example, [AWS networking](https://aws.amazon.com/products/networking/), as well as [internal cluster networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/).

### External

**Konvoy** clusters expose the following HTTP endpoints outside of the cluster:

* Kubernetes API (exposed on port 6443 on a load balancer)
* Traefik Ingress Controller (exposed on port 80/443 on a load balancer)

These endpoints implement [Transport Layer Security (TLS)](https://en.wikipedia.org/wiki/Transport_Layer_Security) to encrypt all traffic to and from the endpoints.

### Internal

**Konvoy** clusters deploy with [Calico](https://www.projectcalico.org) virtual networking, which enables features such as [Kubernetes Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) for shaping and controlling internal cluster networking access.
