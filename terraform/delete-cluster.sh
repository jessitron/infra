if [[ -z $HONEYCOMB_API_KEY ]]
then
  echo "please define HONEYCOMB_API_KEY"
  exit 1
fi

export OTEL_EXPORTER_OTLP_HEADERS="X-Honeycomb-Team=$HONEYCOMB_API_KEY"
export OTEL_EXPORTER_OTLP_ENDPOINT="https://api.honeycomb.io"
export OTEL_SERVICE_NAME="script"

this_program="$0"
echo "This program: $this_program"
root_span=$(otel-cli span --tp-print --name "$this_program"  | grep TRACEPARENT)
echo $root_span
export $root_span #this will put future commands in here

function in_span {
  local command=$*
  echo "Let's run a span around: <$command>"
  otel-cli --name "$command" --attrs "message=hello" exec "$command"
}

#
# Main
#

# aws eks list-nodegroups --cluster-name demo
# in_span aws eks delete-nodegroup --no-cli-pager --nodegroup-name main --cluster-name demo

# aws eks list-clusters
in_span aws eks delete-cluster --no-cli-pager --name demo
