variable "rule_name" { type = string }
variable "schedule_expr" { type = string }
variable "lambda_arn" { type = string }

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = var.rule_name
  schedule_expression = var.schedule_expr
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "lambda-target"
  arn       = var.lambda_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}

output "rule_arn" {
  value = aws_cloudwatch_event_rule.schedule.arn
}
