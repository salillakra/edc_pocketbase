# Use Alpine Linux for a minimal image
FROM alpine:latest

# Install required dependencies
RUN apk add --no-cache \
    ca-certificates \
    unzip \
    wget

# Create a non-root user for running PocketBase
RUN addgroup -g 1000 pocketbase && \
    adduser -D -u 1000 -G pocketbase pocketbase

# Set working directory
WORKDIR /app

# Copy the PocketBase binary (if you have it locally)
# If you want to download it during build, comment out the COPY line and uncomment the download lines below
COPY pocketbase /app/pocketbase

# Alternative: Download PocketBase during build (uncomment these lines if needed)
# ARG PB_VERSION=0.22.20
# RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip \
#     && unzip pocketbase_${PB_VERSION}_linux_amd64.zip \
#     && rm pocketbase_${PB_VERSION}_linux_amd64.zip

# Make PocketBase executable
RUN chmod +x /app/pocketbase

# Create directories for data and migrations
RUN mkdir -p /app/pb_data /app/pb_migrations

# Copy migrations if they exist
COPY pb_migrations /app/pb_migrations

# Change ownership to pocketbase user
RUN chown -R pocketbase:pocketbase /app

# Switch to non-root user
USER pocketbase

# Expose the default PocketBase port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/api/health || exit 1

# Set the entrypoint to run PocketBase
ENTRYPOINT ["/app/pocketbase"]

# Default command to serve PocketBase
CMD ["serve", "--http=0.0.0.0:8080"]
