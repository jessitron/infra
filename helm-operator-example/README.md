# Deploy stuff with helm into my operator-example cluster

## start with a collector

Working from Martin's blog post: https://www.honeycomb.io/deploying-opentelemetry-collector-kubernetes-helm

Find the [latest image](https://hub.docker.com/r/otel/opentelemetry-collector/tags)

Update the chart: `helm repo update open-telemetry`

install with the helm chart which will create a secret for you:

```
helm install my-opentelemetry-collector open-telemetry/opentelemetry-collector --values daemonset-collector-config.yaml --set extraEnvs[0].value=$HONEYCOMB_API_KEY --set extraEnvs[0].name=HONEYCOMB_API_KEY --dry-run
```
