##########################################################################
# S3
##########################################################################
resource "aws_s3_bucket" "kops_state" {
  bucket        = "${var.kops_state_bucket_name}"
  acl           = "${var.acl}"
  region        = "${var.region}"
  force_destroy = "${var.force_destroy}"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name        = "${var.kops_state_bucket_name}"
    Environment = "${var.env}"
  }
}
