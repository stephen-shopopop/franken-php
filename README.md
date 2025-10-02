# FrankenPHP with WordPress

[🇫🇷 Version française](README.fr.md) | 🇬🇧 English version

This project sets up WordPress with FrankenPHP using SQLite as the database, allowing for a lightweight and fast installation without requiring MySQL/MariaDB.

## Prerequisites

- Linux, macOS or WSL (Windows Subsystem for Linux)
- curl
- Administrator rights for global installation (optional)

## Installation

### Option 1: Manual FrankenPHP Installation

```bash
curl https://frankenphp.dev/install.sh | sh
sudo mv frankenphp /usr/local/bin/
```

### Option 2: Automatic Installation (Recommended)

```bash
sh install-wordpress.sh
```

This script automatically installs FrankenPHP and configures WordPress with SQLite.

## Usage

### Serve WordPress (Production Mode)

```bash
./frankenphp php-server -r wordpress/
```

Then access your site at **http://localhost**

### Serve WordPress in Development Mode (Watch Mode)

Watch mode automatically reloads file changes:

```bash
./frankenphp php-server -r wordpress/ --watch
```

### Serve WordPress with Custom Caddyfile

For advanced configuration with Caddy:

```bash
./frankenphp run
```

This command uses the `Caddyfile` present in the directory to configure the server.

## Features

- ✅ **No external database required**: uses SQLite
- ✅ **Modern PHP server**: based on FrankenPHP
- ✅ **Automatic reload**: watch mode for development
- ✅ **Flexible configuration**: supports custom Caddyfiles
- ✅ **Lightweight and fast**: minimal installation

## Project Structure

```
.
├── README.md
├── README.fr.md           # French version
├── install-wordpress.sh   # Automatic installation script
├── Caddyfile             # Caddy configuration (optional)
├── wordpress/            # WordPress directory
└── frankenphp            # FrankenPHP executable
```

## Troubleshooting

### Server Won't Start

Check if port 80 is already in use:

```bash
lsof -i :80
```

To use a different port:

```bash
./frankenphp php-server -r wordpress/ -l :8080
```

### Permission Denied

If you get a permission error, make FrankenPHP executable:

```bash
chmod +x frankenphp
```

## Resources

- [FrankenPHP Documentation](https://frankenphp.dev/)
- [WordPress with SQLite](https://www.alexandergoller.com/journal/15074/wordpress-sqlite-db-integration/)
- [Caddy Documentation](https://caddyserver.com/docs/)

## License

This project uses WordPress (GPL v2+) and FrankenPHP (MIT).
