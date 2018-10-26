#!/bin/bash

S3_BUCKET=s3://mikesoh.com-galactica-backup/mysql-backups/
mysqldump_filename=mysqldump-`date +%Y-%m-%d__%R`.tar.gz

echo running mysqldump...
mysqldump \
    --add-drop-table \
    --routines \
    --events \
    --all-databases \
    --force > /tmp/mysqldump.sql

if [[ $? == 0 ]]; then 
    echo compressing mysqldump file using tar...
    tar czf ${mysqldump_filename} -C /tmp ./mysqldump.sql

    if [[ $? == 0 ]]; then
        echo pushing tar file to S3
        aws s3 cp --sse AES256 ${mysqldump_filename} ${S3_BUCKET}

        if [[ $? == 0 ]]; then
            echo Success!  Removing dump files

            rm -f /tmp/mysqldump*
        else
            echo Fail!  Exit code: $?
            exit $?
        fi
    
    else
        echo tar was not able to successfully compress the mysqldump file.
        echo Exit code: $?
        exit $?
    fi

else
    echo mysqldump had issues.  Exit code: $?
    exit $?
fi
