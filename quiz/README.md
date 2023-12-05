# Frontend for our quiz app

quiz.jessitron.honeydemo.io

I need at least a collector and to serve a JS file
Let's do this in its own namespace.

## Components

### infra

The namespace is defined in `../terraform/quiz.tf`

`ingress.yaml` tries to set up a new ALB for this

the bucket prefix in there was added in `../terraform/main.tf`

### Collector

find the latest version: https://hub.docker.com/r/otel/opentelemetry-collector-contrib/tags

`helm repo update open-telemetry` or something like that

possible values: https://github.com/open-telemetry/opentelemetry-helm-charts/blob/main/charts/opentelemetry-collector/values.yaml

`kubectl create secret generic honeycomb-api-key-for-quiz --from-literal api-key=$HONEYCOMB_API_KEY --namespace quiz`

` helm install --values otel-collector-values.yaml quiz-otelcol open-telemetry/opentelemetry-collector`

and after that you can run `./up otel-collector-values.yaml`

### Frontend

frontend container comes from github.com/jessitron/quiz-booth-game

### a pod to serve the js
