#!/bin/bash

DIRNAME=`dirname $0`
IAM_BASE_URL="http://169.254.169.254/latest/meta-data/iam/security-credentials"
S3CURL_PROFILE="iamrole"
CONFIG_FILE=~/.s3curl


if [ ! -f "$CONFIG_FILE" ]; then
	# fetch machine IAM role key/token details
	IAM_ROLE_NAME=`curl -s $IAM_BASE_URL/`
	IAM_ROLE_DATA=`curl -s $IAM_BASE_URL/$IAM_ROLE_NAME/`
	IAM_ROLE_ACCESS_KEY_ID=`echo "$IAM_ROLE_DATA" | sed -nre 's/.*?"AccessKeyId"[^"]+"([^"]+)",?/\1/p'`
	IAM_ROLE_ACCESS_KEY_SECRET=`echo "$IAM_ROLE_DATA" | sed -nre 's/.*?"SecretAccessKey"[^"]+"([^"]+)",?/\1/p'`
	IAM_ROLE_TOKEN=`echo "$IAM_ROLE_DATA" | sed -nre 's/.*?\"Token\"[^"]+"([^"]+)",?/\1/p'`

	# write details to config file
	echo -e \
		"%awsSecretAccessKeys = (\n" \
		"\t$S3CURL_PROFILE => {\n" \
		"\t\tid => '$IAM_ROLE_ACCESS_KEY_ID',\n" \
		"\t\tkey => '$IAM_ROLE_ACCESS_KEY_SECRET',\n" \
		"\t\ttoken => '$IAM_ROLE_TOKEN'\n" \
		"\t}\n);" > $CONFIG_FILE

	chmod 0600 $CONFIG_FILE
else
	# extract token from config file
	IAM_ROLE_TOKEN=`cat $CONFIG_FILE | sed -nre "s/.*?token[^']+'([^']+)'/\1/p"`
fi

# call s3curl.pl with token and any given arguments
$DIRNAME/s3curl.pl --id $S3CURL_PROFILE -- -H "x-amz-security-token: $IAM_ROLE_TOKEN" $*
