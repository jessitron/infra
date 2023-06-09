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

## iterating

then to iterate:

`helm upgrade --values values.yaml otel-demo open-telemetry/opentelemetry-demo`

## ingress

I couldn't get this to work within the helm chart. And this is not repeatable easily.
But here's what I did

- install that damn alb ingress controller, over in terraform.
- make the helm chart make an ingress rule... really, make any ingress rule. It needed to have the secret annotations, about the ip and the internet-facing (see ingress.yaml)
- run `aws elbv2 describe-load-balancers` to get the deets. That had the hostname in it
- change the ingress rules to have that hostname.

Really now that I'm defining the ingress rules myself, I could change that hostname to a star, and it
would probably work. hmm.

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

## updating charts

What version are we on currently?

`helm list` shows the name of the installation (currently 'sso-demo') and the chart version.

Get the latest version of charts we have used before:

`helm repo update`

I don't know how to list the version of a chart.

`helm search repo opentelemetry-demo`

This lists the current chart version

Check for upgrade instructions:

https://github.com/open-telemetry/opentelemetry-helm-charts/blob/main/charts/opentelemetry-demo/UPGRADING.md

To upgrade to the latest, if there aren't any changes:

`helm upgrade sso-demo open-telemetry/opentelemetry-demo -f values.yaml`

# Ingress

This was easier to setup in straight k8s yaml than in helm/terraform.
I'm gonna need to update the URL somehow though. Where did I get that?

`aws elbv2 describe-load-balancers`

my commit messages are full of info

k8s-oteldemo-22aaaf0b73-1367568571.us-west-2.elb.amazonaws.com

This is the same as before I destroyed and reapplied. I am skeptical.

`helm install otel-demo open-telemetry/opentelemetry-demo`

Now create the ingress by hand:

`k apply -f ingress.yaml`

OK, well, the site is up.

Next I update the deployment of loadgenerator (by hand in k9s) to 0 replicas.
That helps me test, because I only get the traces I create in the frontend.

I'm getting traces but not from the frontend.

OK. The frontend is trying to send to localhost. The env var...maybe it's changed in the upgraded version? nope, I forgot my values.yaml

`helm upgrade otel-demo open-telemetry/opentelemetry-demo --values values.yaml`

Now I can see my values for the env var when I describe the frontend pod (and push d for details) in k9s

Next problem: 502 bad gateway on /v1/traces. Any other url goes to the proxy and 404s or works.

`k port-forward otel-demo-otelcol-667744848b-8ms9t 4318:4318`

This lets me confirm that the collector is listening on 4318 OK
