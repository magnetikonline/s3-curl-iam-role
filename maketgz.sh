#!/bin/bash

chmod 0700 s3curl.pl s3curliamrole.sh
tar czf s3curliamrole.tgz s3curl.pl s3curliamrole.sh --owner=0 --group=0
