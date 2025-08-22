# Franken with wordpress

This wordpress use sqlite.

## Install FrankenPHP

```bash
curl https://frankenphp.dev/install.sh | sh mv frankenphp /usr/local/bin/

or 

sh install-wordpress.sh
```

## Serve the wordpress/ directory

```bash
./frankenphp php-server -r wordpress/
```

Access to ```http://localhost```.

## Serve the wordpress/ directory on watch mode

```bash
./frankenphp php-server -r wordpress/ --watch
```

## Serve the wordpress/ with CaddyFile

```bash
./frankenphp php-server run
```

## Reference

- [doc wordpres + sqlite](https://www.alexandergoller.com/journal/15074/wordpress-sqlite-db-integration/)
