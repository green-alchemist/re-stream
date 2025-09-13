# --- Build Stage ---
FROM debian:bookworm-slim AS builder
WORKDIR /usr/src/app
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential libpcre3-dev libssl-dev zlib1g-dev git wget ca-certificates libperl-dev
RUN git clone https://github.com/arut/nginx-rtmp-module.git && \
    wget http://nginx.org/download/nginx-1.24.0.tar.gz && \
    tar -zxvf nginx-1.24.0.tar.gz && \
    cd nginx-1.24.0 && \
    ./configure \
        --with-http_ssl_module \
        --add-module=../nginx-rtmp-module \
        --with-http_perl_module && \
    make && \
    make install

# --- Final Stage ---
FROM debian:bookworm-slim
# Install runtime dependencies AND 'gettext-base' for the envsubst command
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libpcre3 libssl3 zlib1g perl gettext-base && \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/nginx /usr/local/nginx

# Create a directory for the template
RUN mkdir -p /etc/nginx/templates
# Copy the template file into the image
COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template
# Copy the startup script into the image
COPY start.sh /start.sh
# Make the startup script executable
RUN chmod +x /start.sh

EXPOSE 1935
# Set the startup script as the command to run
CMD ["/start.sh"]