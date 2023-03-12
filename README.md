# what is this

Jess, you want to spin up the OpenTelemetry Demo (its latest version) in an EKS cluster.
You're done creating and deleting clusters by hand, with their node groups etc.

So far this will spin up a cluster, and let you destroy it.

Getting something running in it is another thing

This work is based on the [tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks) as of 11 march 2023.

referencing this [repo](https://github.com/hashicorp/learn-terraform-provision-eks-cluster/blob/27e7dda1c011a933b2652a0067160ccd3e6194a7/main.tf)

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

#### who am i in k8s

kubectl config get-contexts

## TODO

get someone else access to k8s in this cluster. I remember that is tricky.

## about terraform

things i learned in this process

Terraform makes infrastructure declarative.
You define your stuff in \*.tf files (all in one directory), in `resource` blocks.
The kinds of resources it can create are defined in providers, which are plugins. So you can
spin up resources in AWS using the AWS provider.

The great part is that it's easy to remove all these resources with `terraform destroy`. So your aws
bill doesn't get forever inflated by stuff you've lost track of.

So providers are a dependency. Declare them somewhere in a .tf (like terraform.tf). Then resolve and
bring them in using `terraform init`. This writes a file `.terraform.lock.hcl` with the deets (commit that).
It installs stuff into `.terraform` (gitignore that).

Here's the catch with terraform: it can't go look at your AWS stuff and find out the current state, to
compare to the state you want. (Kubernetes does that.) Terraform has to remember which resources it
is managing. It does this with a "backend." By default that's a `terraform.tfstate` in your local filesystem
(don't commit that). This state is actually _critical_ infrastructure. It must not be lost, it must not be
held insecurely (it contains secrets for some resources), it must be shared
by everyone who is gonna update the infrastructure, and also it must
not be altered by multiple people running terraform at the same time.
In real life, you can use Terraform Cloud as a backend, or put it in S3, there's all kinds of tricky bits.
Personally, I'm throwing it in Dropbox so I don't lose it and I can access it from other computers; no one else should touch my infra.

When Terraform creates a resource, it picks up all kinds of data about it, like its IP address and ARN etc etc.
Other resources can use this data in their creation. Terraform makes a dependency tree out of these.

Also `data` blocks seem to pull data out of the sky from providers. Like asking AWS for the names of the AZs in
the current region.

Outputs are neat. They let you print out useful data bits.

Variables are nice. They let you define a piece of data to use in multiple places, including outputs. So we stick region in a variable, and then we can both print it and configure aws with it. (Can we access provider configuration in outputs? maybe could do that directly.) Variables are configurable at the command line too.

Modules. (subdirectories come into play here, for custom ones)
These let you abstract a grouping of related resources. For instance, the "eks" module creates a crapton
of resources in AWS. I wish I could give my instance of the "eks" module a name like I can an individual resource.

Modules as sharable abstractions - there are registries for these. In the enterprise, you'd have yours. I guess there's a global one for public modules... is it the same as where providers are registered?
