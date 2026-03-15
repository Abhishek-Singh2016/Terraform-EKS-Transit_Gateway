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

#password for console login

resource "aws_iam_user_login_profile" "admin" {
  user    = aws_iam_user.admin.name
  #pgp_key = "keybase:some_person_that_exists"
}

output "password" {
value = aws_iam_user_login_profile.admin.encrypted_password
}


output "access_key_id" {
value = aws_iam_access_key.example_user_key.id
}

output "secret_access_key" {
value = aws_iam_access_key.example_user_key.secret
sensitive = true
}