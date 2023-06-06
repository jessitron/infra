if [[ -z $HONEYCOMB_API_KEY ]]
then
  echo "please define HONEYCOMB_API_KEY"
  exit 1
fi

export OTEL_EXPORTER_OTLP_HEADERS="X-Honeycomb-Team=$HONEYCOMB_API_KEY"
export OTEL_EXPORTER_OTLP_ENDPOINT="https://api.honeycomb.io"

root_span=$(otel-cli --name "$0" span --tp-print | grep TRACEPARENT)
echo $root_span


function jsonify {
  jq -n --arg key $1 --arg value $2 '.[$key]=$value'
}

function send_to_hny {
  otel-cli --service "script" --name "spanny boi" --attrs "message=hello" exec echo hi
}

function in_span {
  local command=$*
  echo "Let's run a span around: <$command>"
  send_to_hny
}

#
# Main
#
in_span delete_cluster
