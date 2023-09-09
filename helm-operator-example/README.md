# Deploy stuff with helm into my operator-example cluster

## start with a collector

Working from Martin's blog post: https://www.honeycomb.io/deploying-opentelemetry-collector-kubernetes-helm

Find the [latest image](https://hub.docker.com/r/otel/opentelemetry-collector/tags)

Update the chart: `helm repo update open-telemetry`

install with the helm chart:

```
helm install my-opentelemetry-collector open-telemetry/opentelemetry-collector --values daemonset-collector-config.yaml --set extraEnvs[0].value=$HONEYCOMB_API_KEY --set extraEnvs[0].name=HONEYCOMB_API_KEY --dry-run
```

Turn on its saying stuff:
https://github.com/open-telemetry/opentelemetry-collector/blob/main/docs/troubleshooting.md#logs

#### Testing the collector

I can start up a pod by applying otel-test-pod.yaml. Full instructions in [this blog post](https://jessitron.com/2023/09/08/testing-an-opentelemetry-collector-deployed-as-a-daemonset-in-kubernetes/).

Useful place to find out where this API key is gonna send stuff in hny: [honeycomb-whoami.glitch.me](https://honeycomb-whoami.glitch.me/)
