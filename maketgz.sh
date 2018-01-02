#!/bin/bash -e

chmod 0700 s3curl.pl s3curliamrole.sh

tar \
	--create \
	--file s3curliamrole.tgz \
	--group 0 \
	--gzip \
	--owner 0 \
	s3curl.pl s3curliamrole.sh
