#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

source ./env.sh

ZIP_FILE_NAME="mafiascum.backup.prod.forum.latest.zip"
FORUM_DIR_NAME="forum"
WEB_FORUM_PATH="/var/www-ms/forum"

rm -f "$ZIP_FILE_NAME"
rm -rf "$FORUM_DIR_NAME"

mkdir -p "$FORUM_DIR_NAME/store"
mkdir -p "$FORUM_DIR_NAME/images"
mkdir -p "$FORUM_DIR_NAME/files"

rsync -avz "$WEB_FORUM_PATH/store/" "$FORUM_DIR_NAME/store/"
rsync -avz "$WEB_FORUM_PATH/images/" "$FORUM_DIR_NAME/images/"
rsync -avz "$WEB_FORUM_PATH/files/" "$FORUM_DIR_NAME/files/"

zip -r -e -P "$BACKUP_PASSWORD" "$ZIP_FILE_NAME" "$FORUM_DIR_NAME"
aws s3 cp "$ZIP_FILE_NAME" "s3://$AWS_BUCKET_NAME/web-backups/$ZIP_FILE_NAME"

rm -f "$ZIP_FILE_NAME"
rm -rf forum