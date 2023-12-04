# Frontend for our quiz app

quiz.jessitron.honeydemo.io

I need at least a collector and to serve a JS file
Let's do this in its own namespace.

The namespace is defined in `../terraform/quiz.tf`

Hmm, should it have its own load balancer?
Signs point to "this is fine" (this cluster isn't too expensive yet)

Keeping it separate makes it portable.

Now i have to remember how to set up all the DNS stuff.

## Components

### a pod to serve the js
