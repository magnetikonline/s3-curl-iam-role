#!/bin/bash -e

DIRNAME=$(dirname $0)
IAM_BASE_URL="http://169.254.169.254/latest/meta-data/iam/security-credentials"
S3CURL_PROFILE="iamrole"
CONFIG_FILE="$HOME/.s3curl"


if [[ ! -f $CONFIG_FILE ]]; then
	# fetch machine IAM role key/token details
	IAMRoleName=$(curl -s $IAM_BASE_URL/)
	IAMRoleData=$(curl -s $IAM_BASE_URL/$IAMRoleName/)
	IAMRoleAccessKeyID=$(echo -n "$IAMRoleData" | sed -nr 's/.*?"AccessKeyId"[^"]+"([^"]+)",?/\1/p')
	IAMRoleAccessKeySecret=$(echo -n "$IAMRoleData" | sed -nr 's/.*?"SecretAccessKey"[^"]+"([^"]+)",?/\1/p')
	IAMRoleToken=$(echo -n "$IAMRoleData" | sed -nr 's/.*?"Token"[^"]+"([^"]+)",?/\1/p')

	# write details to config file
	echo -e \
		"%awsSecretAccessKeys = (\n" \
		"\t$S3CURL_PROFILE => {\n" \
		"\t\tid => '$IAMRoleAccessKeyID',\n" \
		"\t\tkey => '$IAMRoleAccessKeySecret',\n" \
		"\t\ttoken => '$IAMRoleToken'\n" \
		"\t}\n);" > $CONFIG_FILE

	chmod 0600 $CONFIG_FILE
else
	# extract token from config file
	IAMRoleToken=$(cat $CONFIG_FILE | sed -nr "s/.*?token[^']+'([^']+)',?/\1/p")
fi

# call s3curl.pl with token and any given arguments
$DIRNAME/s3curl.pl --id $S3CURL_PROFILE -- -H "x-amz-security-token: $IAMRoleToken" $*
