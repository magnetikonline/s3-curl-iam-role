# S3 Curl tool with IAM role support
Bash script to wrap the AWS `s3curl.pl` utility allowing access to S3 buckets via an EC2 assigned IAM role (instance profile).

Upon first call will automatically fetch required IAM role credentials from the `http://169.254.169.254/` endpoint and generate a `~/.s3curl` config for use by `s3curl.pl` which includes the IAM instance profile access token used by [`s3curliamrole.sh`](s3curliamrole.sh).

- [Install & usage](#install--usage)
- [Executing via CloudInit / user-data](#executing-via-cloudinit--user-data)
- [Reference](#reference)

## Install & usage
```sh
# example placement of s3curliamrole.sh/s3curl.pl scripts somewhere public
$ curl -s https://s3.amazonaws.com/BUCKET-NAME/public/s3curliamrole.tgz | tar -xz
$ ./s3curliamrole.sh -s https://s3.amazonaws.com/BUCKET-NAME/path/to/file.ext
```

## Executing via CloudInit / user-data
If calling the script via EC2 user-data (I would think this is a common scenario), you will find (with Ubuntu AMI images at least) that the `$HOME` environment variable will not be defined this early in the instances bootstrap which will cause issues with both `s3curliamrole.sh` and `s3curl.pl`.

Since user-data executes as root, you can combat this by placing the following lines at the start of your user-data scripts:
```sh
#!/bin/bash -e

# setting $HOME since not available yet when run via CloudInit
HOME="/root"
export HOME
```

## Reference
- https://aws.amazon.com/code/amazon-s3-authentication-tool-for-curl/
- http://www.dowdandassociates.com/blog/content/howto-use-s3curl-dot-pl-with-iam-roles/
