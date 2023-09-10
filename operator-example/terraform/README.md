# A cluster to show how an operator can add instrumentation.

Copied from my otel demo cluster (../terraform)

... and now I'm adding helm charts. See [my helm README](../otel-demo-helm/README.md)
for how I got here.

I have added cert-manager

and now I am adding the operator.

Here's where I found the repository and chart name: https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts/opentelemetry-operator#add-repository

Here's how I found the latest version: https://github.com/open-telemetry/opentelemetry-helm-charts/releases

The documentation and the values.yaml don't agree on how to generate a self-signed cert. sad

The docs say

`--set admissionWebhooks.certManager.autoGenerateCert=true`

but in values.yaml, autoGenerateCert is outside of certManager.

... trying it without changing values.yaml

After `terraform apply` I see this in :customresourcedefinitions in k9s:

`opentelemetrycollectors.opentelemetry.io`

yay

The [helm chart docs](https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts/opentelemetry-operator#install-opentelemetry-collector) for the operator have more collector examples than the [operator's own docs](https://github.com/open-telemetry/opentelemetry-operator/blob/main/README.md), at the moment.

I need the schema for the CRD, because the docs are examples.
I managed to get it with this:

`k get customresourcedefinition  opentelemetrycollectors.opentelemetry.io -ojson > crd.json`

This is better than then yaml output by `k describe` because the yaml doesn't collapse properly, and it's unreadable without collapsing (say) additionalContainers.

Ah, but this is better. It has [API Docs](https://github.com/open-telemetry/opentelemetry-operator/blob/main/docs/api.md#opentelemetrycollector).


