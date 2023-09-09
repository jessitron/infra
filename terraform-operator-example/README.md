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
