provider "aws" {
  region = var.region
}

provider "aws" {
    alias = "admin"
    region = var.region
}


resource "aws_iam_user" "admin" {
    name = "${var.cluster_name}-admin"
    path = "/system/${var.cluster_name}/"
}


resource "aws_iam_access_key" "admin" {
  user = aws_iam_user.admin.name
}

resource "aws_iam_user_policy_attachment" "user_poweruser" {
  user       = aws_iam_user.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

