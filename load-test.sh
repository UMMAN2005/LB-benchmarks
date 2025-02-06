#!/bin/bash

# Define the download URL
HEY_URL="https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64"
HEY_FILE="hey_linux_amd64"

# Define your target servers (replace with your public IP)
IP="192.168.1.1"

# Define the ports for HAProxy, NGINX, and Traefik
HAPROXY_PORT=8081
NGINX_PORT=8082
TRAEFIK_PORT=8083

# Number of requests and concurrency (adjust if needed)
REQUESTS=100000
CONCURRENCY=100

# Download HEY if does not exist
if [ ! -f "$HEY_FILE" ]; then
  echo "Downloading hey..."
  wget $HEY_URL
  chmod +x $HEY_FILE
fi

# Run tests for HAProxy
echo "Running test for HAProxy on port $HAPROXY_PORT..."
./$HEY_FILE -n $REQUESTS -c $CONCURRENCY http://$IP:$HAPROXY_PORT

echo ""
echo "----------------------------------------"
echo ""
sleep 10

# Run tests for NGINX
echo "Running test for NGINX on port $NGINX_PORT..."
./$HEY_FILE -n $REQUESTS -c $CONCURRENCY http://$IP:$NGINX_PORT

echo ""
echo "----------------------------------------"
echo ""
sleep 10

# Run tests for Traefik
echo "Running test for Traefik on port $TRAEFIK_PORT..."
./$HEY_FILE -n $REQUESTS -c $CONCURRENCY http://$IP:$TRAEFIK_PORT

echo ""
echo "----------------------------------------"
echo "Test suite completed!"
