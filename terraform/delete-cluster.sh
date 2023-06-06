if [[ -z $HONEYCOMB_API_KEY ]]
then
  echo "please define HONEYCOMB_API_KEY"
  exit 1
fi

export OTEL_EXPORTER_OTLP_HEADERS="X-Honeycomb-Team=$HONEYCOMB_API_KEY"
export OTEL_EXPORTER_OTLP_ENDPOINT="https://api.honeycomb.io"

this_program="$*"
root_span=$(otel-cli span --tp-print --name "this_program"  | grep TRACEPARENT)
echo $root_span
export $root_span #this will put future commands in here

function in_span {
  local command=$*
  echo "Let's run a span around: <$command>"
  otel-cli --service "script" --name "spanny boi" --attrs "message=hello" exec "$command"
}

#
# Main
#
in_span aws eks delete-cluster --name demo
