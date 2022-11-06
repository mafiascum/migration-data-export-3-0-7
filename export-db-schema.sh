#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

DUMP_FILE_NAME="ms_phpbb3_and_ms_mediawiki.sql"
ZIP_FILE_NAME="mafiascum.backup.prod.db.latest.7z"

rm -f "$ZIP_FILE_NAME"
rm -f "$DUMP_FILE_NAME"

mysqldump --user=root --password="$MYSQL_PASSWORD" --databases ms_phpbb3 ms_mediawiki --no-data > "$DUMP_FILE_NAME"
7z -mx=9 -p"$BACKUP_PASSWORD" a "$ZIP_FILE_NAME" "$DUMP_FILE_NAME"

rm -f "$DUMP_FILE_NAME"

aws s3 cp "$ZIP_FILE_NAME" "s3://$AWS_BUCKET_NAME/db-backups/$ZIP_FILE_NAME"

rm -f "$ZIP_FILE_NAME"