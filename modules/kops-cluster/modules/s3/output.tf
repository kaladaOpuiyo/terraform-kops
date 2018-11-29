output "kops_state_store" {
  value = "s3://${replace(aws_s3_bucket.kops_state.arn,"arn:aws:s3:::","")}"
}
