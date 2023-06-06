if [[-z $HONEYCOMB_API_KEY ]]
then
  echo "please define HONEYCOMB_API_KEY"
  exit 1
fi

function jsonify {
  jq -n --arg key $1 --arg value $2 '.[$key]=$value'
}

function send_to_hny {
  local endpoint=https://api.honeycomb.io/1/events/script
  local header="X-Honeycomb-Team: $HONEYCOMB_API_KEY"
  local data=$(jsonify message "Hello")
  echo "Send this: <$data> with header $header"
  curl -H "$header" -X POST -d "$data" $endpoint
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
