#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

source ./env.sh

ZIP_FILE_NAME="mafiascum.backup.${ENVIRONMENT_NAME}.forum.latest.zip"
WEB_FORUM_PATH="/var/www-ms/forum"

rm -f "$ZIP_FILE_NAME"
rm -rf images store files

mkdir -p images store files

rsync -avz "$WEB_FORUM_PATH/store/" "store/"
rsync -avz "$WEB_FORUM_PATH/images/" "images/"
rsync -avz "$WEB_FORUM_PATH/files/" "files/"

zip -r -e -P "$BACKUP_PASSWORD" "$ZIP_FILE_NAME" store images files
aws s3 cp "$ZIP_FILE_NAME" "s3://$AWS_BUCKET_NAME/web-backups/$ZIP_FILE_NAME"

rm -f "$ZIP_FILE_NAME"
rm -rf store images files