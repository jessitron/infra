# Run a cluster that can use the kubernetes operator

This incorporates [my fork of spring-petclinic](https://github.com/jessitron/spring-petclinic),
which contains yaml for deploying the application (in k8s/) and scripts for building and deploying.

[x] spin up a cluster
[x] make petclinic run in it
[x] make a collector run
[x] make the operator run
[x] see traces
  [x] see them in Jaeger
[x] run a collector for events
[x] run a collector for metrics
[ ] see them in grafana
   [ ] make my otel-demo frontend collector have a metrics pipeline, and expose /v1/metrics
[ ] make some sort of dashboard

Improve the traces:
[x] make the petclinic use a real database
[ ] make the database persistent
[ ] give petclinic a better service name than petclinic-deployment
[ ] i can put the collector back as a daemonset now, Austin figured out how to do it
[ ] a real URL
[ ] derived columns in hny so I can make something of the events
[ ] get more resource events from the k8sobjects receiver
[ ] can I add cluster name to all the events?

Blog posts I could make out of this:
- how to include a helm deployment in terraform. A negative of this: terraform can't tell you what it's gonna create.
- labeling your telemetry in the collector, with where it came from
