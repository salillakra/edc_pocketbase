# PocketBase Server

A Dockerized PocketBase server for easy deployment and management.

## 📋 Prerequisites

- Docker installed on your system
- Docker Compose (optional, but recommended)
- Git

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd edc-server
```

### 2. Build the Docker Image

```bash
docker build -t pocketbase-server .
```

### 3. Run the Container

```bash
docker run -d \
  --name pocketbase \
  -p 8080:8080 \
  -v $(pwd)/pb_data:/app/pb_data \
  pocketbase-server
```

### 4. Access PocketBase

Open your browser and navigate to:

- **Admin UI**: http://localhost:8080/\_/
- **API**: http://localhost:8080/api/

## 🐳 Docker Compose (Recommended)

Create a `docker-compose.yml` file:

```yaml
version: "3.8"

services:
  pocketbase:
    build: .
    container_name: pocketbase
    ports:
      - "8080:8080"
    volumes:
      - ./pb_data:/app/pb_data
    restart: unless-stopped
    healthcheck:
      test:
        [
          "CMD",
          "wget",
          "--no-verbose",
          "--tries=1",
          "--spider",
          "http://localhost:8080/api/health",
        ]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 5s
```

Run with Docker Compose:

```bash
# Start the service
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the service
docker-compose down
```

## 📁 Project Structure

```
edc-server/
├── Dockerfile           # Docker configuration
├── pb_migrations/       # Database migrations
├── pb_data/            # Database and uploaded files (not in git)
├── pocketbase          # PocketBase binary (not in git)
├── .gitignore          # Git ignore rules
└── README.md           # This file
```

## 🔧 Configuration

### Environment Variables

You can customize PocketBase behavior using environment variables:

```bash
docker run -d \
  --name pocketbase \
  -p 8080:8080 \
  -e POCKETBASE_ADMIN_EMAIL=admin@example.com \
  -e POCKETBASE_ADMIN_PASSWORD=yourpassword \
  -v $(pwd)/pb_data:/app/pb_data \
  pocketbase-server
```

### Custom Port

To use a different port:

```bash
docker run -d \
  --name pocketbase \
  -p 3000:8080 \
  -v $(pwd)/pb_data:/app/pb_data \
  pocketbase-server
```

Access at: http://localhost:3000

## 🗃️ Database Backups

### Manual Backup

```bash
# Copy pb_data directory
cp -r pb_data pb_data_backup_$(date +%Y%m%d)
```

### Automated Backup Script

```bash
#!/bin/bash
# backup.sh
BACKUP_DIR="backups"
mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/pb_data_$(date +%Y%m%d_%H%M%S).tar.gz pb_data
```

## 📊 Migrations

Migrations are automatically applied when the container starts. Place your migration files in the `pb_migrations/` directory.

## 🛠️ Development

### Local Development

```bash
# Download PocketBase for your OS
wget https://github.com/pocketbase/pocketbase/releases/download/v0.22.20/pocketbase_0.22.20_linux_amd64.zip
unzip pocketbase_0.22.20_linux_amd64.zip
chmod +x pocketbase

# Run locally
./pocketbase serve --http=127.0.0.1:8080
```

### Updating PocketBase Version

Edit the `Dockerfile` and change the `PB_VERSION`:

```dockerfile
ARG PB_VERSION=0.22.20  # Update this version
```

Then rebuild:

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## 🔍 Troubleshooting

### View Container Logs

```bash
docker logs pocketbase
# or with Docker Compose
docker-compose logs -f
```

### Container Won't Start

```bash
# Check if port 8080 is already in use
sudo lsof -i :8080

# Remove old container
docker rm -f pocketbase

# Rebuild
docker-compose up -d --build
```

### Reset Database

```bash
docker-compose down
sudo rm -rf pb_data
docker-compose up -d
```

## 📝 Common Commands

```bash
# Start container
docker-compose up -d

# Stop container
docker-compose down

# Restart container
docker-compose restart

# View logs
docker-compose logs -f

# Access container shell
docker exec -it pocketbase sh

# Check container status
docker ps

# Remove all data and start fresh
docker-compose down -v
sudo rm -rf pb_data
docker-compose up -d
```

## 🔒 Security Notes

- ⚠️ **Never commit** `pb_data/` directory (contains sensitive data)
- ⚠️ **Never commit** `.env` files with credentials
- ✅ Always use strong passwords for admin accounts
- ✅ Use HTTPS in production
- ✅ Keep PocketBase updated to the latest version

## 📚 Resources

- [PocketBase Documentation](https://pocketbase.io/docs/)
- [PocketBase GitHub](https://github.com/pocketbase/pocketbase)
- [Docker Documentation](https://docs.docker.com/)

## 📄 License

[Your License Here]

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Contact

[Your Contact Information]
