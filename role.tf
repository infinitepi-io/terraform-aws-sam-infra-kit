#############################################################################
# Lambda Function Role and Policy
##############################################################################
resource "aws_iam_role" "lambda" {
  provider = aws.primary
  name     = "sam-lambda_${var.name}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })

}

resource "aws_iam_role_policy" "lambda" {
  provider = aws.primary
  for_each = var.custom_policy
  name     = each.key
  policy   = each.value
  role     = aws_iam_role.lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda" {
  provider   = aws.primary
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:${local.aws_primary.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}