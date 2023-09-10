# Deploy stuff with helm into my operator-example cluster

## start with a collector

Working from Martin's blog post: https://www.honeycomb.io/deploying-opentelemetry-collector-kubernetes-helm

Find the [latest image](https://hub.docker.com/r/otel/opentelemetry-collector/tags)

Update the chart: `helm repo update open-telemetry`

install with the helm chart:

```
helm install daemonset-opentelemetry-collector open-telemetry/opentelemetry-collector --values daemonset-collector-config.yaml --dry-run
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

## install the operator

the [docs](https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/set-up-end-to-end-encryption-for-applications-on-amazon-eks-using-cert-manager-and-let-s-encrypt.html) say I need a cert manager.

AWS [recommends](https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/set-up-end-to-end-encryption-for-applications-on-amazon-eks-using-cert-manager-and-let-s-encrypt.html) [cert-manager.io]()

So I followed its [instructions](https://cert-manager.io/docs/installation/#default-static-install) and did this:

`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.4/cert-manager.yaml`

I don't know how to see that in k9s.

Next, the operator docs say to do this:

`kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml`

well this is scary and opaque.

## The operator doesn't work with a daemonset

It wants to set the exporter URL the same for everyone.

So let's run the collector as a deployment, with a service in front of it.

`helm install service-opentelemetry-collector open-telemetry/opentelemetry-collector --values service-collector-config.yaml`
