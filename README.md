# Gitolite Helm Chart

Gitolite to be used in a kubernetes cluster

Hosting git repositories -- Gitolite allows you to setup git hosting on
a central server, with very fine-grained access control and many (many!) more
powerful features.

* http://gitolite.com

Using the docker image created by jgiannuzzi
* https://hub.docker.com/r/jgiannuzzi/gitolite/

## Chart Details
This chart will do the following:

* Installs gitolite with port 22 exposed
* Installs your public key as administrator

## Installing the Chart

To install the chart:

```bash
$ helm install --set SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" --set SSH_KEY_NAME="$(whoami)" gitolite
```

## Configuration

The following tables lists the configurable parameters of the chart and their default values.

| Parameter                  | Description                          | Default                                                                      |
| -------------------------- | ------------------------------------ | ---------------------------------------------------------------------------- |
| `SSH_KEY`                  | Public key of admin                  | ``                                                                           |
| `SSH_KEY_NAME`             | Admin user name                      | `admin`                                                                      |
| `Name`                     | Name                                 | `gitolite`                                                                   |
| `Image`                    | Image name                           | `jgiannuzzi/gitolite`                                                        |
| `ImageTag`                 | Image tag                            | `latest`                                                                     |
| `ImagePullPolicy`          | Image pull policy                    | `IfNotPresent`                                                               |
| `Component`                | k8s selector key                     | `gitolite`                                                                   |
| `Cpu`                      | Requested cpu                        | `200m`                                                                       |
| `Memory`                   | Requested memory                     | `256Mi`                                                                      |
| `ServiceType`              | k8s service type                     | `LoadBalancer`                                                               |
| `ServicePort`              | k8s service port                     | `22`                                                                         |
| `NodePort`                 | k8s node port                        | Not set                                                                      |
| `ContainerPort`            | Listening port                       | `22`                                                                         |
| `LoadBalancerSourceRanges` | Allowed inbound IP addresses         | `0.0.0.0/0`                                                                  |
| `LoadBalancerIP`           | Optional fixed external IP           | Not set                                                                      |
| `Ingress.Annotations`      | Ingress annotations                  | `{}`                                                                         |
| `Ingress.TLS`              | Ingress TLS configuration            | `[]`                                                                         |
| `NodeSelector`             | Node labels for pod assignment       | `{}`                                                                         |
| `Tolerations`              | Toleration labels for pod assignment | `{}`                                                                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --set SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" --set SSH_KEY_NAME="$(whoami)" -f values.yaml gitolite
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## NetworkPolicy

To make use of the NetworkPolicy resources created by default,
install [a networking plugin that implements the Kubernetes
NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin).

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

## Persistence

The Gitolite image stores persistence under `/var/lib/git` path of the container. A dynamically managed Persistent Volume
Claim is used to keep the data across deployments, by default. This is known to work in GCE, AWS, and minikube. Alternatively,
a previously configured Persistent Volume Claim can be used.

It is possible to mount several volumes using `Persistence.volumes` and `Persistence.mounts` parameters.

### Persistence Values for ssh-keys of openssh server

| Parameter                           | Description               | Default         |
| ----------------------------------- | ------------------------- | --------------- |
| `Persistence.SshKeys.Enabled`       | Enable the use of a PVC   | `true`          |
| `Persistence.SshKeys.ExistingClaim` | Provide the name of a PVC | `nil`           |
| `Persistence.SshKeys.AccessMode`    | The PVC access mode       | `ReadWriteOnce` |
| `Persistence.SshKeys.Size`          | The size of the PVC       | `1Gi`           |

### Persistence Values for git repository

| Parameter                       | Description               | Default         |
| ------------------------------- | ------------------------- | --------------- |
| `Persistence.Git.Enabled`       | Enable the use of a PVC   | `true`          |
| `Persistence.Git.ExistingClaim` | Provide the name of a PVC | `nil`           |
| `Persistence.Git.AccessMode`    | The PVC access mode       | `ReadWriteOnce` |
| `Persistence.Git.Size`          | The size of the PVC       | `8Gi`           |

### Additional volumes/mounts

| Parameter                   | Description               | Default         |
| ----------------------------| ------------------------- | --------------- |
| `Persistence.volumes`       | Additional volumes        | `nil`           |
| `Persistence.mounts`        | Additional mounts         | `nil`           |

#### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart
```bash
$ helm install --name my-release --set Persistence.ExistingClaim=PVC_NAME gitolite
```

