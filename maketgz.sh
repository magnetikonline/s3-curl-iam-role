#!/bin/bash

chmod 0700 s3curl.pl s3curliamrole.sh

tar -czf s3curliamrole.tgz \
	--owner=0 --group=0 \
	s3curl.pl s3curliamrole.sh
