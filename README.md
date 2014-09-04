# S3 Curl tool with IAM role support
Bash script to wrap the AWS `s3curl.pl` utility allowing access to S3 buckets via EC2 assigned IAM roles.

On first call will automatically fetch required IAM role credentials from the usual `http://169.254.169.254/` endpoint and generate a valid `~/.s3curl` config, including the access token used by the [`s3curliamrole.sh`](s3curliamrole.sh) script.

## Install & usage
```sh
# example placement of s3curliamrole.sh/s3curl.pl scripts somewhere public
$ curl -s https://s3.amazonaws.com/BUCKET-NAME/public/s3curliamrole.tgz | tar xz
$ ./s3curliamrole.sh -s https://s3.amazonaws.com/BUCKET-NAME/path/to/file.ext
```

## Reference
- http://aws.amazon.com/code/128
- http://www.dowdandassociates.com/blog/content/howto-use-s3curl-dot-pl-with-iam-roles/
