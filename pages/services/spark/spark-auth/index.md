---
layout: layout.pug
title: Configuring DC/OS Access for Spark
menuWeight: 1010
excerpt:
featureMaturity:
enterprise: true
---

This topic describes how to configure DC/OS access for Spark. Depending on your [security mode](/1.9/security/ent/#security-modes/), Spark requires [service authentication](/1.10/security/ent/service-auth/) for access to DC/OS.

| Security mode | Service Account |
|---------------|-----------------------|
| Disabled      | Not available   |
| Permissive    | Optional   |
| Strict        | Required |

If you install a service in disabled mode, it will use the default `dcos_anonymous` account to authenticate. The `dcos_anonymous` account has the [superuser permission](/1.10/security/ent/perms-reference/#superuser).

**Prerequisites:**

- [DC/OS CLI installed](/1.9/cli/install/) and be logged in as a superuser.
- [Enterprise DC/OS CLI 0.4.14 or later installed](/1.9/cli/enterprise-cli/#ent-cli-install).

# <a name="create-a-keypair"></a>Create a Key Pair
In this step, a 2048-bit RSA public-private key pair is created uses the Enterprise DC/OS CLI (install with `dcos package install dcos-enterprise-cli` if you haven't already).

Create a public-private key pair and save each value into a separate file within the current directory.

```bash
dcos security org service-accounts keypair <private-key>.pem <public-key>.pem
```

**Tip:** You can use the [DC/OS Secret Store](/1.10/security/ent/secrets/) to secure the key pair.

# <a name="create-a-service-account"></a>Create a Service Account

From a terminal prompt, create a new service account (`<service-account-id>`) containing the public key (`<your-public-key>.pem`).

```bash
dcos security org service-accounts create -p <your-public-key>.pem -d "Spark service account" <service-account-id>
```

**Tip:** You can verify your new service account using the following command.

```bash
dcos security org service-accounts show <service-account-id>
```

# <a name="create-an-sa-secret"></a>Create a Secret
Create a secret (`spark/<secret-name>`) with your service account (`<service-account-id>`) and private key specified (`<private-key>.pem`).

**Tip:** If you store your secret in a path that matches the service name (e.g. service name and secret path are `spark`), then only the service named `spark` can access it.

## Permissive

```bash
dcos security secrets create-sa-secret <private-key>.pem <service-account-id> spark/<secret-name>
```

## Strict

```bash
dcos security secrets create-sa-secret --strict <private-key>.pem <service-account-id> spark/<secret-name>
```

**Tip:**
You can list the secrets with this command:

```bash
dcos security secrets list /
```

# <a name="give-perms"></a>Create and Assign Permissions
Use the following DC/OS CLI commands to rapidly provision the Spark service account with the required permissions. This can also be done through the UI.

**Tips:**

- Permissions can also be created in the UI using the same permission string such as `dcos:mesos:master:framework:role:* create`


1.  Create the permissions, please note: some of these permissions may exist already.

    **Important:** Spark runs by default under the [Mesos default role](http://mesos.apache.org/documentation/latest/roles/), which is represented by the `*` symbol. You can deploy multiple instances of Spark without modifying this default. If you want to override the default Spark role, you must modify these code samples accordingly.

    **Important:** RHEL/CentOS users cannot currently run Spark in strict mode as user `nobody`, but must run as user `root`. This is due to how accounts are mapped to uid's. CoreOS users are unaffected, and can run as user `nobody`.

    Run these commands with your service account name (`<service-account-id>`) specified, and ('<user>') defined as `nobody` or `root`.

    ```bash
    dcos security org users grant spark dcos:mesos:master:task:user:<user> create --description "Allows the Linux user to execute tasks"
    dcos security org users grant spark dcos:mesos:master:framework:role:* create --description "Allows a framework to register with the Mesos master using the Mesos default role"
    dcos security org users grant spark dcos:mesos:master:task:app_id:/<service-account-id> create --description "Allows reading of the task state"
    ```


# <a name="create-json"></a>Create a Configuration File
Create a custom configuration file that will be used to install Spark and save as `config.json`.

Specify the service account (`<service-account-id>`), secret (`spark/<secret-name>`) and ('<user>'), defined as `nobody` for CoreOS and `root` for RHEL/CentOS.


```json
{
    "service": {
            "service_account": "<service-account-id>",
            "user": "<user>",
            "service_account_secret": "spark/<secret_name>"
    }
}
```

## <a name="install-spark"></a>Install Spark

Now, Spark can be installed with this command:

```bash
dcos package install --options=config.json spark
```

**Note** You can install the Spark Mesos Dispatcher to run as `root` by substituting `root` for `nobody` above. If you are running a strict mode cluster, you must give Marathon the necessary permissions to launch the Dispatcher task. Use the following command to give Marathon the appropriate permissions:

```bash
dcos security org users grant spark dcos:mesos:master:task:user:root/users/dcos_marathon create
``` 

## <a name="Run a Job"></a>Run a Job

To run a job on a strict mode cluster, you must add the `principal` to the command line. For example:
```bash
dcos spark run --verbose --submit-args=" \
--conf spark.mesos.principal=spark \
--conf spark.mesos.containerizer=mesos \
--class org.apache.spark.examples.SparkPi http://downloads.mesosphere.com/spark/assets/spark-examples_2.11-2.0.1.jar 100"
```

If you want to use the [Docker Engine](/1.10/deploying-services/containerizers/docker-containerizer/) instead of the [Universal Container Runtime](/1.10/deploying-services/containerizers/ucr/), you must specify the user through the `SPARK_USER` environment variable: 

```bash
dcos spark run --verbose --submit-args="\
--conf spark.mesos.principal=spark \
--conf spark.mesos.driverEnv.SPARK_USER=nobody \
--class org.apache.spark.examples.SparkPi http://downloads.mesosphere.com/spark/assets/spark-examples_2.11-2.0.1.jar 100"
```

