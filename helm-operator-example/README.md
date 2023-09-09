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

`kubectl exec otel-test-pod -i --tty -- bash`

Useful place to find out where this API key is gonna send stuff in hny: [honeycomb-whoami.glitch.me](https://honeycomb-whoami.glitch.me/)

#### Putting the APIKey in a secret

Now I need to update the API key, might as well do it right. For this I'm working from [here](https://jessitron.com/2022/08/22/run-the-opentelemetry-collector-in-kubernetes-for-front-end-tracing/#put-in-secret)

I did this:

`kubectl create secret generic honeycomb-api-key --from-literal=api-key=<api key for modernity/petclinic>`
