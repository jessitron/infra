# what is this

Jess, you want to spin up the OpenTelemetry Demo (its latest version) in an EKS cluster.
You're done creating and deleting clusters by hand, with their node groups etc.

So far this will spin up a cluster, and let you destroy it.

Getting something running in it is another thing

#### print the version of the aws cli

aws --version

#### who am i on aws

aws sts get-caller-identity

##### terraform version

terraform --version

#### update terraform with:

`brew upgrade terraform`

#### what resources are managed by terraform right now?

`terraform state list`
