# migration-data-export-3-0-7
MS Data Migration For phpBB 3.0.7 to phpBB 3.3.x

Instructions:

1) Clone this repository on the current MS production server
2) Copy `env-sample.sh` to `env.sh`
3) Edit `env.sh` and fill in the variables in the file
4) Run `export-db.sh` to export the forum & wiki database schemas & data to file and push to S3. This will also remove the `phpbb_posts` & `phpbb_posts_archive` fulltext indexes.  This will be stored in a format that can be used by the `forum-deployment` repo to import as a snapshot.
5) Run `export-web-forum.sh` to export the forum web files and push to S3. This will be stored in a format that can be used by the `forum-deployment` repo to import on container startup.
6) Run `export-web-wiki.sh` to export the wiki web files and push to S3.  This will be stored in a format that can be used by the `forum-deployment` repo to import on container startup.