# Baseline scan - terraform/insecure

- Passed: 22
- Failed: 52

| Check ID | Count | Description |
|---|---|---|
| CKV2_AWS_6 | 2 | Ensure that S3 bucket has a Public Access block |
| CKV2_AWS_61 | 2 | Ensure that an S3 bucket has a lifecycle configuration |
| CKV2_AWS_62 | 2 | Ensure S3 buckets should have event notifications enabled |
| CKV_AWS_145 | 2 | Ensure that S3 buckets are encrypted with KMS by default |
| CKV_AWS_144 | 2 | Ensure that S3 bucket has cross-region replication enabled |
| CKV_AWS_18 | 2 | Ensure the S3 bucket has access logging enabled |
| CKV_AWS_21 | 2 | Ensure all data stored in the S3 bucket have versioning enabled |
| CKV_AWS_273 | 1 | Ensure access is controlled through SSO and not AWS IAM defined users |
| CKV_AWS_63 | 1 | Ensure no IAM policies documents allow "*" as a statement's actions |
| CKV_AWS_62 | 1 | Ensure IAM policies that allow full "*-*" administrative privileges are not created |
| CKV_AWS_289 | 1 | Ensure IAM policies does not allow permissions management / resource exposure without constraints |
| CKV_AWS_288 | 1 | Ensure IAM policies does not allow data exfiltration |
| CKV_AWS_290 | 1 | Ensure IAM policies does not allow write access without constraints |
| CKV_AWS_355 | 1 | Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions |
| CKV_AWS_40 | 1 | Ensure IAM policies are attached only to groups or roles (Reducing access management complexity may in-turn reduce opportunity for a principal to inadvertently receive or retain excessive privileges.) |
| CKV_AWS_286 | 1 | Ensure IAM policies does not allow privilege escalation |
| CKV_AWS_287 | 1 | Ensure IAM policies does not allow credentials exposure |
| CKV_AWS_60 | 1 | Ensure IAM role allows only specific services or principals to assume it |
| CKV_AWS_158 | 1 | Ensure that CloudWatch Log Group is encrypted by KMS |
| CKV_AWS_338 | 1 | Ensure CloudWatch log groups retains logs for at least 1 year |
| CKV_AWS_66 | 1 | Ensure that CloudWatch Log Group specifies retention days |
| CKV_AWS_7 | 1 | Ensure rotation for customer created CMKs is enabled |
| CKV_AWS_149 | 1 | Ensure that Secrets Manager secret is encrypted using KMS CMK |
| CKV_AWS_36 | 1 | Ensure CloudTrail log file validation is enabled |
| CKV_AWS_35 | 1 | Ensure CloudTrail logs are encrypted at rest using KMS CMKs |
| CKV_AWS_67 | 1 | Ensure CloudTrail is enabled in all Regions |
| CKV_AWS_252 | 1 | Ensure CloudTrail defines an SNS Topic |
| CKV_AWS_25 | 1 | Ensure no security groups allow ingress from 0.0.0.0:0 to port 3389 |
| CKV_AWS_24 | 1 | Ensure no security groups allow ingress from 0.0.0.0:0 to port 22 |
| CKV_AWS_23 | 1 | Ensure every security group and rule has a description |
| CKV_AWS_382 | 1 | Ensure no security groups allow egress from 0.0.0.0:0 to port -1 |
| CKV_AWS_3 | 1 | Ensure all data stored in the EBS is securely encrypted |
| CKV_AWS_189 | 1 | Ensure EBS Volume is encrypted by KMS using a customer managed Key (CMK) |
| CKV_AWS_54 | 1 | Ensure S3 bucket has block public policy enabled |
| CKV_AWS_53 | 1 | Ensure S3 bucket has block public ACLS enabled |
| CKV_AWS_56 | 1 | Ensure S3 bucket has 'restrict_public_buckets' enabled |
| CKV_AWS_55 | 1 | Ensure S3 bucket has ignore public ACLs enabled |
| CKV_AWS_70 | 1 | Ensure S3 bucket does not allow an action with any Principal |
| CKV2_AWS_12 | 1 | Ensure the default security group of every VPC restricts all traffic |
| CKV2_AWS_57 | 1 | Ensure Secrets Manager secrets should have automatic rotation enabled |
| CKV2_AWS_11 | 1 | Ensure VPC flow logging is enabled in all VPCs |
| CKV2_AWS_5 | 1 | Ensure that Security Groups are attached to another resource |
| CKV2_AWS_10 | 1 | Ensure CloudTrail trails are integrated with CloudWatch Logs |
| CKV2_AWS_40 | 1 | Ensure AWS IAM policy does not allow full IAM privileges |
| CKV2_AWS_64 | 1 | Ensure KMS key Policy is defined |
