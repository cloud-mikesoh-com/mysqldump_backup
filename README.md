# mysqldump backup to AWS S3

This script creates a mysqldump of a mysql database and pushes it to S3 for archiving.  It's designed to be run as a cron job nightly with an S3 bucket that replicates these backups accordingly.

