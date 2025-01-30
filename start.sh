#!/bin/bash

CURRENT_PORT=""

# Function to update the qbittorrent port
update_port () {
  PORT=$1

  sed -i 's/listen_port:.*/listen_port: '\"$PORT\"'/' $SLSKD_CONFIG_FILE

  echo "Successfully updated slskd to port $PORT"
}

# Main loop to check the port and update if necessary
while true; do
  # Fetch the forwarded port
  PORT_FORWARDED=$(curl -s ${HTTP_S}://${GLUETUN_HOST}:${GLUETUN_PORT}/v1/openvpn/portforwarded | awk -F: '{gsub(/[^0-9]/,"",$2); print $2}')
  
  # Check if the fetched port is valid
  if [[ -z "$PORT_FORWARDED" || ! "$PORT_FORWARDED" =~ ^[0-9]+$ ]]; then
    echo "Failed to retrieve a valid port number."
    sleep 10
    continue
  fi

  # If the current port is different from the forwarded port, update it
  if [[ "$CURRENT_PORT" != "$PORT_FORWARDED" ]]; then
    update_port "$PORT_FORWARDED"
  fi

  # Wait for a specific interval before checking again
  sleep $RECHECK_TIME
done