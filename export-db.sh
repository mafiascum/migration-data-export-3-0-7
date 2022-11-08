#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

source ./env.sh

DUMP_FILE_NAME="ms_phpbb3_and_ms_mediawiki.sql"
ZIP_FILE_NAME="mafiascum.backup.${ENVIRONMENT_NAME}.db.latest.7z"
EXPORT_TABLES="ms_phpbb3 ms_mediawiki"
MYSQL_EXTRA_FLAGS="--lock-tables=false --routines --triggers"

rm -f "$ZIP_FILE_NAME"
rm -f "$DUMP_FILE_NAME"

mysqldump $MYSQL_EXTRA_FLAGS --user=root --password="$MYSQL_PASSWORD" --databases $EXPORT_TABLES --no-data \
 | grep -E -v 'FULLTEXT KEY `((post_content)|(post_text)|(post_subject))`' \
 | sed 's/^ \+KEY `tid_post_time` (`topic_id`,`post_time`),/  KEY `tid_post_time` (`topic_id`,`post_time`)/g' > "$DUMP_FILE_NAME"
mysqldump $MYSQL_EXTRA_FLAGS --user=root --password="$MYSQL_PASSWORD" --databases $EXPORT_TABLES --no-create-info >> "$DUMP_FILE_NAME"
7z -mx=1 -p"$BACKUP_PASSWORD" a "$ZIP_FILE_NAME" "$DUMP_FILE_NAME"

rm -f "$DUMP_FILE_NAME"

aws s3 cp "$ZIP_FILE_NAME" "s3://$AWS_BUCKET_NAME/db-backups/$ZIP_FILE_NAME"

rm -f "$ZIP_FILE_NAME"
