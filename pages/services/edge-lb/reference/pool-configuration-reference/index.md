---
layout: layout.pug
navigationTitle:  Edge-LB Pool Configuration
title: Pool configuration reference (V2)
menuWeight: 84
excerpt: Provides reference information and examples for Edge-LB pool configurations options in the V2 API

enterprise: true
---

The tables in this section describe all possible configuration options. Most configuration options have default values that are applicable and appropriate for most organizations. You can modify the default configuration values to suit your requirements, if needed. However, you should review and test any configuration changes carefully before deploying them to a production environment.

# Before you modify configuration settings
If you plan to modify the Edge-LB pool configuration options, you should keep the following guidelines in mind:
- If a configuration option does not have a default value and you do not explicitly set a value, the configuration is left as empty (unconfigured), even for objects.
- You should set default values in the object that is furthest from the root object.
- You should always set a default for arrays.
- The purpose of a "nullable" configuration option is to allow the output JSON field to be set to the Go language "zero value". Without "nullable" support, the configuration option would be removed from the resulting JSON.
- Actual validation is done in the code, not expressed in swagger.
- If the data type for a configuration option is a boolean, an empty value is interpreted as "false". For boolean configuration options, you should not set a default value.
- Use CamelCase to set configuration values.
- Swagger only validates enumerated (enum) data values if the configuration option is a top level definition.

# API version compatibility
There are two versions of the Edge-LB API specification. The top-level configuration field `apiVersion` is used to distinguish between the two versions of the API specification. The two models are almost identical, with one important difference: `pool.haproxy.backends.servers` (in `apiVersion` V1) has been replaced with `pool.haproxy.backends.services` to a more intuitive way to select services and backends for HAProxy load balancers. Because the specifications are nearly identical, the reference information in this section provides details for the latest version of the Edge-LB API specification (V2). If you need information for the older specification, see [Edge-LB pool configuration (v1)](/services/edge-lb/reference/v1-reference/).

The V1 and V2 specifications were merged into a single spec; however, there are still separate v1 and v2 docs for reference configs, pool examples, etc.


<a name="pool"></a>

# pool
The pool contains information on resources that the pool needs. Changes made to this section will relaunch the tasks.
<table class="table" style="table-layout: fixed">
<tr>
<th style="font-weight:bold">Key</th>
<th style="font-weight:bold">Type</th>
<th style="font-weight:bold">Nullable</th><th style="font-weight:bold">Properties</th>
<th style="font-weight:bold">Description</th>
</tr>
<tbody valign="top">
<tr>
<td>apiVersion</td><td>string</td><td></td><td></td><td>Specifies the API schema version of this pool object. Should be V2 for new pools.</td>
</tr>
<tr><td>name</td><td>string</td><td></td><td></td><td>Specifies the pool name.</td>
</tr>
<tr><td>namespace</td><td>string</td><td>true</td><td></td><td>Specifies the DC/OS space (sometimes also referred to as a "group").</td>
</tr>
<tr><td>packageName</td><td>string</td><td></td><td></td><td>Specifies the Edge-LB package name</td></tr>
<tr><td>packageVersion</td><td>string</td> <td></td><td></td></tr>
<tr><td>role</td><td>string</td><td></td><td></td> <td>Mesos role for load balancers. Defaults to "slave_public" so that load balancers will be run on public agents. Use "*" to run load balancers on private agents. For more information, see <a href="http://mesos.apache.org/documentation/latest/roles/">Mesos roles</a>. </td></tr>
<tr><td>cpus</td><td>number</td><td></td><td></td></tr>
<tr><td>cpusAdminOverhead</td><td>number</td><td></td><td></td><tr>
<tr><td>mem</td><td>int32</td><td></td><td></td><td>Memory requirements (in MB).</td></tr>
<tr><td>memAdminOverhead</td><td>int32</td></td><td></td><td>Memory requirements (in MB).</td></tr>
<tr><td>disk</td><td>int32</td></td><td></td><td>Disk size (in MB).</td></tr>
<tr><td>count</td><td>integer<td>true</td><td><td>Number of load balancer instances in the pool.</td></tr>
<tr><td>count</td><td>integer<td>true</td><td><td>Number of load balancer instances in the pool.</td></tr>
<tr><td>count</td><td>integer<td>true</td><td></td><td>Number of load balancer instances in the pool.</td></tr>
<tr><td>constraints</td><td>string</td>true<td></td><td>Marathon style constraints for load balancer instance placement.</td></tr>
<tr><td>ports</td><td>array</td><td></td><td>                 | <ul><li>Override ports to allocate for each load balancer instance.</li><li>Defaults to {{haproxy.frontend.objs[].bindPort}} and {{haproxy.stats.bindPort}}.</li><li>Use this field to pre-allocate all needed ports with or without the frontends present. For example: [80, 443, 9090].</li><li>If the length of the ports array is not zero, only the ports specified will be allocated by the pool scheduler.</li></ul> |
<tr><td>items</td><td>int32</td><td></td><td></td></tr>
<tr><td>secrets</td><td>array</td><td></td><td>
<ul><li>[secret](#secrets-prop)</li><li>[file](#secrets-prop)</li></ul> | DC/OS secrets. |
<tr><td>environmentVariables</td><td>object</td><td>[additionalProperties](#env-var)</td><td>Environment variables to pass to tasks. Prefix with `ELB_FILE_` and it will be written to a file. For example, the contents of `ELB_FILE_MYENV` will be written to `$ENVFILE/ELB_FILE_MYENV`.</td></tr>
<tr><td>autoCertificate</td><td>boolean  |             |                 | Autogenerate a self-signed SSL/TLS certificate. It is not generated by default. It will be written to `$AUTOCERT`. |
<tr><td>virtualNetworks</td><td>array</td><td></td><td></td><td><ul><li>[name](#vn-prop)</li><li>[labels](#vn-prop)</li></ul> | Virtual networks to join.</td></tr>
<tr><td>haproxy</td><td></td><td></td></tr>
<tr><td>poolHealthcheckGracePeriod</td><td>int32</td><td><td></td><td></td><td>Defines the period of time after start of the pool container when failed healtchecks will be ignored (default: 180s). Introduced in v1.2.3.</td></tr>
<tr><td>poolHealthcheckInterval</td><td>int32</td><td></td><td></td><td>Defines healthcheck execution interval. At most one healtcheck is going to execute at any given time (default: 12s). Introduced in v1.2.3.</td></tr>
<tr><td>poolHealthcheckMaxFail</td><td>int32</td><td></td><td></td><td>Defines how many consecutive failures mark the task as failed and force Mesos to kill it (default: 5). Introduced in v1.2.3.</td></tr>
<tr><td>poolhealthcheckTimeout</td><td>int32</td><td></td><td>Defines the timeout enforced by Mesos on the healthcheck execution. It includes the container startup (fetch, setup, start, etc...) as well as the time spent by the healthcheck command executing the test. Introduced in v1.2.3.</td></tr>
</tbody>
</table>

<a name="secrets-prop"></a>

## pool.secrets

| Key           | Type        | Description |
| ------------- | ----------- | ----------- |
| secret        | object      |             |

### pool.secrets.secret

| Key           | Type        | Description |
| ------------- | ----------- | ----------- |
| secret        | string      | Secret name. |
| file          | string      | File name.<br />The file `myfile` will be found at `$SECRETS/myfile`. |

<a name="env-var"></a>

## pool.environmentVariables

| Key                   | type        | Description |
| --------------------- | ----------- | ----------- |
| additionalProperties  | string      | Environment variables to pass to tasks.<br />Prefix with "ELB_FILE_" and it will be written to a file. For example, the contents of "ELB_FILE_MYENV" will be written to "$ENVFILE/ELB_FILE_MYENV". |

<a name="vn-prop"></a>

## pool.virtualNetworks

| Key           | Type        | Description |
| ------------- | ----------- | ----------- |
| name          | string      | The name of the virtual network to join. |
| labels        | string      | Labels to pass to the virtual network plugin. |

<a name="haproxy-prop"></a>

# pool.haproxy

| Key             | Type    | Description         |
| --------------- | ------- | ------------------- |
| stats           |         |                     |
| frontends       | array   | Array of frontends. |
| backends        | array   | Array of backends.  |

<a name="stats-prop"></a>

# pool.haproxy.stats

| Key            | Type     |
| -------------- | -------- |
| bindAddress    | string   |
| bindPort       | int 32   |

<a name="frontend-prop"></a>

# pool.haproxy.frontend

| Key             | Type    | Properties     | Description    | x-nullable | Format |
| --------------- | ------- | -------------- | -------------- | ---------- | ------ |
| name            | string  |                | Defaults to `frontend_{{bindAddress}}_{{bindPort}}`.  |   |   | bindAddress     | string  |                | Only use characters that are allowed in the frontend name. Known invalid frontend name characters include `*`, `[`, and `]`.  |   |   |
| bindPort        | integer |                | The port (e.g. 80 for HTTP or 443 for HTTPS) that this frontend will bind to.  |   | int32  |
| bindModifier    | string  |                | Additional text to put in the bind field   |   |   |
| certificates    | array   |                | SSL/TLS certificates in the load balancer.<br /><br />For secrets, use `$SECRETS/my_file_name`<br />For environment files, use `$ENVFILE/my_file_name`<br />For autoCertificate, use `$AUTOCERT`.<br />type: string  |   |   |
| redirectToHttps | object  | <ul><li>[except](#redirect-https-prop)</li><li>[items](#redirect-https-prop)</li></ul>  | Setting this to the empty object is enough to redirect all traffic from HTTP (this frontend) to HTTPS (port 443). Default: except: [] |   |   |
| miscStrs        | array of strings  |   | Additional template lines inserted before use_backend  |   |   |
| protocol        |   |   | The frontend protocol is how clients/users communicate with HAProxy.  |   |   |
| linkBackend     | object  | <ul><li>defaultBackend</li><li>map</li></ul>  | This describes what backends to send traffic to. This can be expressed with a variety of filters such as matching on the hostname or the HTTP URL path.<br />Default: map: []   |   |   |

<a name="redirect-https-prop"></a>

## pool.haproxy.frontend.redirectToHttps

| Key             | Type    | Properties  | Description     |
| --------------- | ------- | ----------- | --------------- |
| except          | array   |             | You can additionally set a whitelist of fields that must be matched to allow HTTP.  |
| items           | object  | <ul><li>[host](#items-prop)</li><li>[pathBeg](#items-prop)</li></ul> | Boolean AND will be applied with every selected value. |

<a name="items-prop"></a>

### pool.frontend.redirectToHttps.items

| Key             | Type    | Description |
| --------------- | ------- | ----------- |
| host            | string  | Match on host. |
| pathBeg         | string  | Math on path.  |

## pool.haproxy.frontend.linkBackend

| Key             | Type    | Properties | Description |
| --------------- | ------- | ---------- | ----------- |
| defaultBackend  | string  |            | This is default backend that is routed to if none of the other filters are matched.  |
| map             | array   | <ul><li>[backend](#map-prop)</li><li>[hostEq](#map-prop)</li><li>[hostReg](#map-prop)</li><li>[pathBeg](#map-prop)</li><li>[pathEnd](#map-prop)</li><li>[pathReg](#map-prop)</li></ul> | This is an optional field that specifies a mapping to various backends. These rules are applied in order.<br />"Backend" and at least one of the condition fields must be filled out. If multiple conditions are filled out, they will be combined with a boolean "AND". |

<a name="map-prop"></a>

### pool.frontend.linkBackend.map

| Key             | Type    | Description |
| --------------- | ------- | ----------- |
| backend         | string  |             |
| hostEq          | string  | Must be all lowercase. |
| hostReg         | string  | Must be all lowercase. It is possible for a port (e.g. `foo.com:80`) to be in this regex.  |
| pathBeg         | string  |             |
| pathEnd         | string  |             |
| pathReg         | string  |             |

<a name="backend-prop"></a>

# pool.haproxy.backend

| Key             | Type    | Properties     | Description    |
| --------------- | ------- | -------------- | -------------- |
| name            | string  |                | The name the frontend refers to. |
| protocol        | string  |                | The backend protocol is how HAProxy communicates with the servers it is load balancing. |
| rewriteHttp     |         |                | Manipulate HTTP headers. There is no effect unless the protocol is either HTTP or HTTPS. |
| balance         | string  |                | Load balancing strategy. E.g., roundrobin, leastconn, etc. |
| customCheck     | object  | <ul><li>[httpchk](#customCheck-prop)</li><li>[httpchkMiscStr](#customCheck-prop)</li><li>[sslHelloChk](#customCheck-prop)</li><li>[miscStr](#customCheck-prop)</li></ul>  | Specify alternate forms of healthchecks.  |
| miscStrs        | array of strings |       | Additional template lines inserted before servers  |
| services        | array   |                | Array of backend service selectors.  |

<a name="customCheck-prop"></a>

## pool.haproxy.backend.customCheck

| Key            | Type     |
| -------------  | -------- |
| httpchk        | boolean  |
| httpchkMiscStr | string   |
| sslHelloChk    | boolean  |
| miscStr        | string   |

<a name="#rewrite-prop"></a>

# pool.haproxy.backend.rewriteHttp

| Key             | Type    | Properties     | Description    |
| --------------- | ------- | -------------- | -------------- |
| host            | string  |                | Set the host header value. |
| path            | object  | <ul><li>[fromPath](#path-prop)</li><li>[toPath](#path-prop)</li></ul>  | Rewrite the HTTP URL path. All fields required, otherwise it's ignored.  |
| request         |         |                |                |
| response        |         |                |                |
| sticky          | object  | <ul><li>[enabled](#sticky-prop)</li><li>[customStr](#sticky-prop)</li></ul>  | Sticky sessions via a cookie.<br />To use the default values (recommended), set this field to the empty object.  |

<a name="path-prop"></a>

## pool.haproxy.backend.rewriteHttp.path

| Key             | Type    |
| --------------- | ------- |
| fromPath        | string  |
| toPath          | string  |

<a name="sticky-prop"></a>

## pool.haproxy.backend.rewriteHttp.sticky

| Key             | Type    | nullable   |
| --------------- | ------- | ---------- |
| enabled         | boolean | true       |
| customStr       | string  |            |

<a name="rewrite-req-prop"></a>

# pool.haproxy.backend.rewriteHttp.request

| Key                         | Type       | nullable   |
| --------------------------- | ---------- | ---------- |
| forwardfor                  | boolean    | true       |
| xForwardedPort              | boolean    | true       |
| xForwardedProtoHttpsIfTls   | boolean    | true       |
| setHostHeader               | boolean    | true       |
| rewritePath                 | boolean    | true       |

<a name="rewrite-resp-prop"></a>

# pool.haproxy.backend.rewriteHttp.response

| Key             | Type       | nullable   |
| --------------- | ---------- | ---------- |
| rewriteLocation | boolean    | true       |

<a name="service-prop)"></a>

# pool.haproxy.backend.service

| Key             | Type       |
| --------------- | ---------- |
| marathon        | object     |
| mesos           | object     |
| endpoint        | object     |

<a name="service-marathon-prop)"></a>

# pool.haproxy.backend.service.marathon

| Key                  | Type      | Description                                                       |
| -----------          | --------- | -----------                                                       |
| serviceID            | string    | Marathon pod or application ID.                                   |
| serviceIDPattern     | string    | serviceID as a regex pattern.                                     |
| containerName        | string    | Marathon pod container name, optional unless using Marathon pods. |
| containerNamePattern | string    | containerName as a regex pattern.                                 |

<a name="service-mesos-prop)"></a>

# pool.haproxy.backend.service.mesos

| Key                  | Type      | Description                       |
| -----------          | --------- | -----------                       |
| frameworkName        | string    | Mesos framework name.             |
| frameworkNamePattern | string    | frameworkName as a regex pattern. |
| frameworkID          | string    | Mesos framework ID.               |
| frameworkIDPattern   | string    | frameworkID as a regex pattern.   |
| taskName             | string    | Mesos task name.                  |
| taskNamePattern      | string    | taskName as a regex pattern.      |
| taskID               | string    | Mesos task ID.                    |
| taskIDPattern        | string    | taskID as a regex pattern.        |

<a name="service-endpoint-prop)"></a>

# pool.haproxy.backend.service.endpoint

| Key         | Type      | Description                                                                                   |
| ----------- | --------- | -----------                                                                                   |
| type        | string    | Enum field, can be `AUTO_IP`, `AGENT_IP`, `CONTAINER_IP`, or `ADDRESS`. Default is `AUTO_IP`. |
| miscStr     | string    | Append arbitrary string to add to the end of the "server" directive.                          |
| check       | object    | Enable health checks. These are by default TCP health checks. For more options see "customCheck". These are required for DNS resolution to function properly. |
| address     | string    | Server address override, can be used to specify a cluster internal address such as a VIP. Only allowed when using type `ADDRESS`. |
| port   | integer | Port number.                                                                                  |
| portName | string | Name of port.                                                                      |
| allPorts  | boolean | Selects all ports defined in service when `true`.                     |

<a name="service-endpoint-check-prop)"></a>

# pool.haproxy.backend.service.endpoint.check

| Key         | Type      |
| ----------- | --------- |
| enabled     | boolean   |
| customStr   | string    |

<a name="error-prop"></a>

# error

| Key             | Type        |
| --------------- | ----------- |
| code            | int32       |
| message         | string      |

# Applying pool configuration settings
The code excerpts in this section provide examples of how to set Edge-LB pool configuration options using the Edge-LB REST API.

## Using Edge-LB pool for a sample Marathon application

DC/OS services are typically run as applications on the Marathon framework. To create a pool configuration file for a Marathon application, you need to know the Mesos `task` name and `port` name.

For example, in the following snippet from a sample Marathon app definition:
* the `task` name is `my-app`
* the `port` name is `web`

```json
{
  "id": "/my-app",
  ...
  "portDefinitions": [
    {
      "name": "web",
      "protocol": "tcp",
      "port": 0
    }
  ]
}
```

The following code provides a simple example of how to configure an Edge-LB pool to do load-balancing for the sample Marathon application above:

```json
{
  "apiVersion": "V2",
  "name": "app-lb",
  "count": 1,
  "haproxy": {
    "frontends": [{
      "bindPort": 80,
      "protocol": "HTTP",
      "linkBackend": {
        "defaultBackend": "app-backend"
      }
    }],
    "backends": [{
      "name": "app-backend",
      "protocol": "HTTP",
      "services": [{
        "marathon": {
          "serviceID": "/my-app"
        },
        "endpoint": {
          "portName": "web"
        }
      }]
    }]
  }
}
```

## Path-based routing

This pool configures a load balancer which sends traffic to the `httpd` backend unless the path begins with `/nginx`, in which case it sends traffic to the `nginx` backend. The path in the request is rewritten before getting sent to nginx.

```json
{
  "apiVersion": "V2",
  "name": "path-routing",
  "count": 1,
  "haproxy": {
    "frontends": [{
      "bindPort": 80,
      "protocol": "HTTP",
      "linkBackend": {
        "defaultBackend": "httpd",
        "map": [{
          "pathBeg": "/nginx",
          "backend": "nginx"
        }]
      }
    }],
    "backends": [{
      "name": "httpd",
      "protocol": "HTTP",
      "services": [{
        "marathon": {
          "serviceID": "/host-httpd"
        },
        "endpoint": {
          "portName": "web"
        }
      }]
    },{
      "name": "nginx",
      "protocol": "HTTP",
      "rewriteHttp": {
        "path": {
          "fromPath": "/nginx",
          "toPath": "/"
        }
      },
      "services": [{
        "mesos": {
          "frameworkName": "marathon",
          "taskName": "bridge-nginx"
        },
        "endpoint": {
          "portName": "web"
        }
      }]
    }]
  }
}
```

Here are some examples of how the path would be changed for different `fromPath` and `toPath` values:

* `fromPath: "/nginx"`, `toPath: ""`, request: `/nginx` -> `/`
* `fromPath: "/nginx"`, `toPath: "/"`, request: `/nginx` -> `/`
* `fromPath: "/nginx"`, `toPath: "/"`, request: `/nginx/` -> `/`
* `fromPath: "/nginx"`, `toPath: "/"`, request: `/nginx/index.html` -> `/index.html`
* `fromPath: "/nginx"`, `toPath: "/"`, request: `/nginx/subpath/index.html` -> `/subpath/index.html`
* `fromPath: "/nginx/"`, `toPath: ""`, request: `/nginx` -> `/nginx` (The path is not rewritten in this case because the request did not match `/nginx/`)
* `fromPath: "/nginx/"`, `toPath: ""`, request: `/nginx/` -> `/`
* `fromPath: "/nginx"`, `toPath: "/subpath"`, request: `/nginx` -> `/subpath`
* `fromPath: "/nginx"`, `toPath: "/subpath"`, request: `/nginx/` -> `/subpath/`
* `fromPath: "/nginx"`, `toPath: "/subpath"`, request: `/nginx/index.html` -> `/subpath/index.html`
* `fromPath: "/nginx"`, `toPath: "/subpath/"`, request: `/nginx/index.html` -> `/subpath//index.html` (Note that for cases other than `toPath: ""` or `toPath: "/"`, it is suggested that the `fromPath` and `toPath` either both end in `/`, or neither do because the rewritten path could otherwise end up with a double slash.)
* `fromPath: "/nginx/"`, `toPath: "/subpath/"`, request: `/nginx/index.html` -> `/subpath/index.html`

We used `pool.haproxy.frontend.linkBackend.pathBeg` in this example to match on the beginning of a path. Other useful fields are:

* `pathBeg`: Match on path beginning
* `pathEnd`: Match on path ending
* `pathReg`: Match on a path regular expression

## Internal (East / West) load balancing

Sometimes it is desired or necessary to use Edge-LB for load balancing traffic inside of a DC/OS cluster. This can also be done using [Minuteman VIPs](/latest/networking/load-balancing-vips), but if you need layer 7 functionality, Edge-LB can be configured for internal only traffic.

The changes necessary are:

* Change the `pool.haproxy.stats.bindPort`, `pool.haproxy.frontend.bindPort` to some port that is available on at least one private agent.
* Change the `pool.role` to something other than `slave_public` (the default). Usually `"*"` works unless you have created a separate role for this purpose.

```json
{
  "apiVersion": "V2",
  "name": "internal-lb",
  "role": "*",
  "count": 1,
  "haproxy": {
    "stats": {
      "bindPort": 15001
    },
    "frontends": [{
      "bindPort": 15000,
      "protocol": "HTTP",
      "linkBackend": {
        "defaultBackend": "app-backend"
      }
    }],
    "backends": [{
      "name": "app-backend",
      "protocol": "HTTP",
      "services": [{
        "marathon": {
          "serviceID": "/my-app"
        },
        "endpoint": {
          "portName": "web"
        }
      }]
    }]
  }
}
```

## Using static DNS and virtual IP addresses

Internal addresses such as those generated by Mesos-DNS, Spartan, or Minuteman VIPs can be exposed outside of the cluster with Edge-LB by using `pool.haproxy.backend.service.endpoint.type: "ADDRESS"`.

It should also be noted that this is not always a good idea. Exposing secured internal services to the outside world using an insecure endpoint can be dangerous, keep this in mind when using this feature.

```json
{
  "apiVersion": "V2",
  "name": "dns-lb",
  "count": 1,
  "haproxy": {
    "frontends": [{
      "bindPort": 80,
      "protocol": "HTTP",
      "linkBackend": {
        "defaultBackend": "app-backend"
      }
    }],
    "backends": [{
      "name": "app-backend",
      "protocol": "HTTP",
      "services": [{
        "endpoint": {
          "type": "ADDRESS",
          "address": "myapp.marathon.l4lb.thisdcos.directory",
          "port": 555
        }
      }]
    }]
  }
}
```

## Using Edge-LB with other frameworks and data services

You can use Edge-LB load balancing for frameworks and data services that run tasks not managed by Marathon. For example, you might have tasks managed by Kafka brokers or Cassandra. For tasks that run under other frameworks and data services, you can use the `pool.haproxy.backend.service.mesos` object to filter and select tasks for load balancing.

```json
{
  "apiVersion": "V2",
  "name": "services-lb",
  "count": 1,
  "haproxy": {
    "frontends": [{
      "bindPort": 1025,
      "protocol": "TCP",
      "linkBackend": {
        "defaultBackend": "kafka-backend"
      }
    }],
    "backends": [{
      "name": "kafka-backend",
      "protocol": "TCP",
      "services": [{
        "mesos": {
          "frameworkName": "beta-confluent-kafka",
          "taskNamePattern": "^broker-*$"
        },
        "endpoint": {
          "port": 1025
        }
      }]
    }]
  }
}
```

Other useful fields for selecting frameworks and tasks in `pool.haproxy.backend.service.mesos`:

* `frameworkName`: Exact match
* `frameworkNamePattern`: Regular expression
* `frameworkID`: Exact match
* `frameworkIDPattern`: Regular expression
* `taskName`: Exact match
* `taskNamePattern`: Regular expression
* `taskID`: Exact match
* `taskIDPattern`: Regular expression

## Using host name and SNI routing with VHOSTS

To direct traffic based on the hostname to multiple backends for a single port (such as 80 or 443), use `pool.haproxy.frontend.linkBackend`.

```json
{
  "apiVersion": "V2",
  "name": "vhost-routing",
  "count": 1,
  "haproxy": {
    "frontends": [{
      "bindPort": 80,
      "protocol": "HTTP",
      "linkBackend": {
        "map": [{
          "hostEq": "nginx.example.com",
          "backend": "nginx"
        },{
          "hostReg": "*.httpd.example.com",
          "backend": "httpd"
        }]
      }
    },{
      "bindPort": 443,
      "protocol": "HTTPS",
      "linkBackend": {
        "map": [{
          "hostEq": "nginx.example.com",
          "backend": "nginx"
        },{
          "hostReg": "*.httpd.example.com",
          "backend": "httpd"
        }]
      }
    }],
    "backends": [{
      "name": "httpd",
      "protocol": "HTTP",
      "services": [{
        "marathon": {
          "serviceID": "/host-httpd"
        },
        "endpoint": {
          "portName": "web"
        }
      }]
    },{
      "name": "nginx",
      "protocol": "HTTP",
      "services": [{
        "mesos": {
          "frameworkName": "marathon",
          "taskName": "bridge-nginx"
        },
        "endpoint": {
          "portName": "web"
        }
      }]
    }]
  }
}
```

## Setting weighted values for backend servers

To add relative weights to backend servers, use the `pool.haproxy.backend.service.endpoint.miscStr` field. In the example below, the `/app-v1` service will receive 20 out of every 30 requests, and `/app-v2` will receive the remaining 10 out of every 30 requests. The default weight is 1, and the max weight is 256.

This approach can be used to implement some canary or A/B testing use cases.

```json
{
  "apiVersion": "V2",
  "name": "app-lb",
  "count": 1,
  "haproxy": {
    "frontends": [{
      "bindPort": 80,
      "protocol": "HTTP",
      "linkBackend": {
        "defaultBackend": "default"
      }
    }],
    "backends": [{
      "name": "default",
      "protocol": "HTTP",
      "services": [{
        "marathon": {
          "serviceID": "/app-v1"
        },
        "endpoint": {
          "portName": "web",
          "miscStr": "weight 20"
        }
      },{
        "marathon": {
          "serviceID": "/app-v2"
        },
        "endpoint": {
          "portName": "web",
          "miscStr": "weight 10"
        }
      }]
    }]
  }
}
```

## Using SSL/TLS certificates

There are three different ways to get and use a certificate:

### Automatically generated self-signed certificate

```json
{
  "apiVersion": "V2",
  "name": "auto-certificates",
  "count": 1,
  "autoCertificate": true,
  "haproxy": {
    "frontends": [
      {
        "bindPort": 443,
        "protocol": "HTTPS",
        "certificates": [
          "$AUTOCERT"
        ],
        "linkBackend": {
          "defaultBackend": "host-httpd"
        }
      }
    ],
    "backends": [{
      "name": "host-httpd",
      "protocol": "HTTP",
      "services": [{
        "marathon": {
          "serviceID": "/host-httpd"
        },
        "endpoint": {
          "portName": "web"
        }
      }]
    }]
  }
}
```

### DC/OS Secrets (Enterprise Only)

```json
{
  "apiVersion": "V2",
  "name": "secret-certificates",
  "count": 1,
  "autoCertificate": false,
  "secrets": [
    {
      "secret": "mysecret",
      "file": "mysecretfile"
    }
  ],
  "haproxy": {
    "frontends": [
      {
        "bindPort": 443,
        "protocol": "HTTPS",
        "certificates": [
          "$SECRETS/mysecretfile"
        ],
        "linkBackend": {
          "defaultBackend": "host-httpd"
        }
      }
    ],
    "backends": [{
      "name": "host-httpd",
      "protocol": "HTTP",
      "services": [{
        "marathon": {
          "serviceID": "/host-httpd"
        },
        "endpoint": {
          "portName": "web"
        }
      }]
    }]
  }
}
```

### Environment variables (Insecure)

```json
{
  "apiVersion": "V2",
  "name": "env-certificates",
  "count": 1,
  "autoCertificate": false,
  "environmentVariables": {
    "ELB_FILE_HAPROXY_CERT": "-----BEGIN CERTIFICATE-----\nfoo\n-----END CERTIFICATE-----\n-----BEGIN RSA PRIVATE KEY-----\nbar\n-----END RSA PRIVATE KEY-----\n"
  },
  "haproxy": {
    "frontends": [
      {
        "bindPort": 443,
        "protocol": "HTTPS",
        "certificates": [
          "$ENVFILE/ELB_FILE_HAPROXY_CERT"
        ],
        "linkBackend": {
          "defaultBackend": "host-httpd"
        }
      }
    ],
    "backends": [{
      "name": "host-httpd",
      "protocol": "HTTP",
      "services": [{
        "marathon": {
          "serviceID": "/host-httpd"
        },
        "endpoint": {
          "portName": "web"
        }
      }]
    }]
  }
}
```

## Using virtual networks

In this example we create a pool that will be launched on the virtual network provided by DC/OS overlay called "dcos". In general you can launch a pool on any CNI network, by setting `pool.virtualNetworks[].name` to the CNI network name.

```json
{
  "apiVersion": "V2",
  "name": "vnet-lb",
  "count": 1,
  "virtualNetworks": [
    {
      "name": "dcos",
      "labels": {
        "key0": "value0",
        "key1": "value1"
      }
    }
  ],
  "haproxy": {
    "frontends": [{
      "bindPort": 80,
      "protocol": "HTTP",
      "linkBackend": {
        "defaultBackend": "vnet-be"
      }
    }],
    "backends": [{
      "name": "vnet-be",
      "protocol": "HTTP",
      "services": [{
        "marathon": {
          "serviceID": "/my-vnet-app"
        },
        "endpoint": {
          "portName": "my-vnet-port"
        }
      }]
    }]
  }
}
```
