# Run a cluster that can use the kubernetes operator

This incorporates [my fork of spring-petclinic](https://github.com/jessitron/spring-petclinic),
which contains yaml for deploying the application (in k8s/) and scripts for building and deploying.

[x] spin up a cluster
[x] make petclinic run in it
[x] make a collector run
[x] make the operator run
[x] see traces
  [ ] see them in Jaeger
[ ] run a collector for events
[ ] run a collector for metrics
  [ ] see them in grafana

Improve the traces:
[ ] make the petclinic use a real database
