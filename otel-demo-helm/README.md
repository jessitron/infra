# installation of otel demo

installing opentelemetry-demo.

based on: https://opentelemetry.io/docs/demo/kubernetes-deployment/

but I want mine to

- have frontend traces
- send to hny
- be available publicly
- run my own fork of the code, so i can change it.

## what i have done

`helm install otel-demo open-telemetry/opentelemetry-demo`

this eventually got a bunch of stuff running in k8s

`kubectl port-forward svc/otel-demo-frontendproxy 8080:8080`

to test it with local connection.

buy a thing at

`localhost:8080/`

then look for traces at

`localhost:8080/jaeger`

(this took some retrying, it wasn't reliable, but whatevs, it's all-in-one toy mode)

## stuff about helm

#### version of helm

`helm version`

it's installed with brew, so

`brew upgrade helm`

should update it now.

### what we know about helm

Right. Helm abstracts installation of particular applications on kubernetes.

How to install an app is defined in a "chart." Charts are published to repositories.

When you install an app in your k8s cluster, that's a "release." It gets a name.
