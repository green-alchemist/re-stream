#!/bin/sh

# This script uses the 'envsubst' command to substitute environment variables
# in the template file and create the final nginx.conf.
# The single quotes are important to specify which variables to substitute.
envsubst '${TWITCH_KEY},${YOUTUBE_KEY},${KICK_KEY}' < /etc/nginx/templates/nginx.conf.template > /usr/local/nginx/conf/nginx.conf

# Start NGINX in the foreground
# 'exec' is important to ensure NGINX becomes the main process (PID 1)
exec /usr/local/nginx/sbin/nginx -g "daemon off;"