# irc-k8s

## Overview

### service.yaml

Since k8s doesn't yet support port ranges in service definitions, we have to
use a special template to generate the service definition.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: irssi-mosh
  namespace: default
  annotations:
    metallb.universe.tf/address-pool: k3s-pool
    metallb.universe.tf/allow-shared-ip: "true"
spec:
  type: LoadBalancer
  ipFamilyPolicy: PreferDualStack
  ipFamilies:
    - IPv6
    - IPv4
  externalTrafficPolicy: Local
  ports:
    - name: ssh
      port: 2222
      targetPort: 22
      protocol: TCP
    {{ range seq 60000 61000 }}
    - port: {{ . }}
      targetPort: {{ . }}
      protocol: UDP
      name: mosh-{{ . }}
    {{ end }}
  selector:
    app: irssi-mosh
```

```shell
 gomplate -f lotsofports.yaml > service.yaml
 ```