resource "aws_iam_user" "admin" {
  name = "learning-tf-eks"
  path = "/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "admin" {
  user = aws_iam_user.admin.name
}

data "aws_iam_policy_document" "admin" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "admin" {
  name   = "admin-tf-eks"
  user   = aws_iam_user.admin.name
  policy = data.aws_iam_policy_document.admin.json
}