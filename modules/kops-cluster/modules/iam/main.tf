#############################################################################
# IAM
#############################################################################
resource "aws_iam_group" "kops" {
  name = "kops"
}

resource "aws_iam_group_policy_attachment" "kops_attach" {
  count      = "${length(var.kops_attach_policy)}"
  group      = "${aws_iam_group.kops.name}"
  policy_arn = "arn:aws:iam::aws:policy/${element(var.kops_attach_policy,count.index)}"
}

resource "aws_iam_user" "kops" {
  name = "kops"
}

resource "aws_iam_user_group_membership" "kops_membership" {
  user = "${aws_iam_user.kops.name}"

  groups = [
    "${aws_iam_group.kops.name}",
  ]
}

resource "aws_iam_access_key" "kops" {
  user = "${aws_iam_user.kops.name}"
}
