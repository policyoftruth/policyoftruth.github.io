resource "aws_iam_group" "kops_group" {
  name = "kops"
}

resource "aws_iam_group_policy_attachment" "kops_group_policy_attach" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  ])
  group      = aws_iam_group.kops_group.name
  policy_arn = each.key
}

resource "aws_iam_user" "kops_user" {
  name = "kops"
}

resource "aws_iam_user_group_membership" "kops_user_group" {
  user = aws_iam_user.kops_user.name

  groups = [
    aws_iam_group.kops_group.name,
  ]
}
