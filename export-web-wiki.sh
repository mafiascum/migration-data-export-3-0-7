#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

source ./env.sh

ZIP_FILE_NAME="mafiascum.backup.${ENVIRONMENT_NAME}.wiki.latest.zip"
WEB_WIKI_PATH="/var/www-ms/wiki"

rm -rf images
rm -f "$ZIP_FILE_NAME"

mkdir -p images

rsync -avz "$WEB_WIKI_PATH/images" images/

zip -r -e -P "$BACKUP_PASSWORD" "$ZIP_FILE_NAME" images/
aws s3 cp "$ZIP_FILE_NAME" "s3://$AWS_BUCKET_NAME/web-backups/$ZIP_FILE_NAME"

rm -f "$ZIP_FILE_NAME"
rm -rf images