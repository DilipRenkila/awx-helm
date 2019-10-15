# Ansible AWX

Helm deployement of Ansible AWX on Kubernetes

## Introduction

This chart bootstraps an [AWX](https://github.com/ansible/awx) deployment on
a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh)
package manager. This chart requires [metrics-server](https://github.com/kubernetes-incubator/metrics-server) be installed in order for the hpa to
gather metrics.

## Pre-Config
If using ingress.tls (enabled by default) you will need to update the `templates/secrets.yaml`
with the base64 encoded crt and key file

## Installing the Chart

To install the chart with the release name `awx` in the `ansible` namespace:

```console
helm dep up ./awx-helm
helm install --name awx --namespace ansible ./awx-helm
```

The command deploys AWX on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured
during installation.

This charts embeds chart dependencies specified in the requirements.yaml file:

- postgresql

## Uninstalling the Chart

To uninstall/delete the `awx` deployment:

```console
helm delete --purge awx
kubectl delete pvc --all -n ansible
kubectl delete horizontalpodautoscaler.autoscaling/awx-hpa -n ansible
```

The command removes all the Kubernetes components associated with the chart
and deletes the release.

## Configuration

The following table lists the configurable parameters of the
awx chart and their default values.
Postgresql, memcached, rabbitmq charts values can be overridden in
awx/values.yaml

Parameter | Description | Default
--------- | ----------- | -------
`controller.kind` | controller kind | `StatefulSet`
`controller.StatefulSet.replicaCount` | Pod replica count | `1`
`controller.autoscaling.enabled` | Autoscaling enabled (bool) | `true`
`controller.autoscaling.minReplicas` | minimum number of replicas for the hpa | `3`
`controller.autoscaling.maxReplicas` | maximum number of replicas for the hpa | `10`
`controller.autoscaling.targetCPUUtilizationPercentage` | hpa metrics target cpu | `80`
`controller.autoscaling.targetMemoryUtilizationPercentage` | hpa metrics target memory | `80`
`controller.annotations` | annotations for the default controller | `{}`
`awx_web.image.repository` | awx-web image repository | `ansible/awx_web`
`awx_web.image.tag` | awx-web image version/tag | `7.0.0`
`awx_web.image.pullPolicy` | awx-web container image pull policy | `Always`
`awx_web.resources.requests.cpu` | awx-web container cpu | `500m`
`awx_web.resources.requests.memory` | awx-web container memory | `1Gi`
`awx_task.image.repository` | awx-task image repository | `ansible/awx_task`
`awx_task.image.tag` | awx-task image version/tag | `7.0.0`
`awx_task.image.pullPolicy` | awx-task container image pull policy  | `IfNotPresent`
`awx_task.resources.requests.cpu` | awx_task container cpu | `1500m`
`awx_task.resources.requests.memory` | awx_task container memory | `2Gi`
`awx_rabbitmq.resources.requests.cpu` | Configure cpu requests for awx-abbitmq | `500m`
`awx_rabbitmq.resources.requests.memory` | Configure memory requests for awx-rabbitmq | `2Gi`
`awx_memcached.resources.requests.cpu` | Configure cpu requests for awx-memcached | `500m`
`awx_memcached.resources.requests.memory` | Configure memory requests for awx-memcached | `1Gi`
`awx_postgresql.resources.limits.cpu` | Configure cpu limits for awx-postgresql | `500m`
`awx_postgresql.resources.limits.memory` | Configure memory limits for awx-postgresql | `512Mi`
`secret_key` | default secret_key | `awxsecret`
`admin_user` | default admin user for AWX | `admin`
`admin_password` | default admin password for AWX | `password`
`pg_username` | postgresql awx username | `awx`
`pg_password` | postgresql awx password | `awxpass`
`pg_admin_password` | postgresql admin password | `postgrespass`
`pg_database` | postgresql awx db name | `awx`
`pg_port` | postgresql db port | `5432`
`rabbitmq_user` | rabbitmq awx username | `awx`
`rabbitmq_password` | rabbitmq awx password | `awxpass`
`rabbitmq_erlang_cookie` | rabbitmq erlang cookie | `cookiemonster`
`insights_url_base` | insights url base | `"https://example.org"`
`ingress.enabled` | Enable default ingress | `true`
`postgresql.install` | Install postgresql chart | `true`
`postgresql.image.registry` | postgresql image registry | `docker.io`
`postgresql.image.repository` | postgresql image version/tag | `9.6`
`postgresql.image.tag` | postgresql image repository | `bitnami/postgresql`
`postgresql.postgresqlUsername` | postgresql username | `awx`
`postgresql.postgresqlPassword` | postgresql password | `awxpass`
`postgresql.postgresqlDatabase` | postgresql database | `awx`
`postgresql.persistence.enabled` | postgresql persistence | `true`
`postgresql.metrics.enabled` | postgresql metrics | `false`
`postgresql.resources.limits.memory` | postgresql memory limits | `512Mi`
`postgresql.resources.limits.cpu` | postgresql cpu limits | `500m`
`service.type` | service type | `ClusterIP`
`service.port` | service port | `80`
`configure_ldap.enabled` | Enable LDAP | `true`
`configure_ldap.allow_anonymous_bind` | Allow anonymous bind | `true`
`configure_ldap.ldap_bind_username` | LDAP bind username | `changeme`
`configure_ldap.ldap_bind_password` | LDAP bind password | `changeme`
`configure_ldap.ldap_bind_ou` | LDAP bind ou | `ou=people,dc=example,dc=com`
`configure_ldap.ldap_server_uri` | LDAP server uri | `ldap://192.168.1.2:389`
`configure_ldap.ldap_user_search` | LDAP user search dn | `ou=people,dc=example,dc=com`
`configure_ldap.ldap_group_search_dn` | LDAP group search dn | `ou=ExampleGroup,ou=CompanyGroups,dc=example,dc=com`
`configure_ldap.ldap_superuser_group` | LDAP superuser group | `CN=Admin-Group,ou=CompanyGroups,dc=example,dc=com`
`configure_ldap.organizations` | LDAP organizations | `null`