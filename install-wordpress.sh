#!/bin/bash
 
# Define variables
WORDPRESS=https://wordpress.org/latest.tar.gz
WORDPRESS_TAR=latest.tar.gz
PLUGIN_URL="https://downloads.wordpress.org/plugin/sqlite-database-integration.zip"
PLUGIN=sqlite-database-integration
PLUGIN_ZIP="$PLUGIN.zip"
PLUGIN_DIR="./wordpress/wp-content/plugins"
DB_COPY_SRC="$PLUGIN_DIR/$PLUGIN/db.copy"
DB_COPY_DEST="wordpress/wp-content/db.php"
WP_CONFIG=wp-config.php

# Download wordpress and extract
curl -O $WORDPRESS
tar xzf $WORDPRESS_TAR

# Download the plugin zip file
curl -o $PLUGIN_ZIP $PLUGIN_URL
 
# Unzip the plugin to the plugins directory
unzip -o $PLUGIN_ZIP
mv $PLUGIN $PLUGIN_DIR
 
# Copy the db.copy to the destination
cp $DB_COPY_SRC $DB_COPY_DEST

# Add wp-config
cp config/$WP_CONFIG wordpress/$WP_CONFIG
 
# Clean up
rm $PLUGIN_ZIP
rm $WORDPRESS_TAR

# Install frankenphp
curl https://frankenphp.dev/install.sh | sh 
mv frankenphp /usr/local/bin/
