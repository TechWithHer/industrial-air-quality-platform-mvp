resource "aws_cloudwatch_event_rule" "collector_schedule" {

  name = "iaqap-dev-collector-schedule"

  description = "Run collector every 15 minutes"

  schedule_expression = "rate(15 minutes)"

}

resource "aws_cloudwatch_event_target" "collector_target" {

  rule = aws_cloudwatch_event_rule.collector_schedule.name

  arn = aws_lambda_function.collector.arn

}
resource "aws_lambda_permission" "allow_eventbridge" {

  statement_id = "AllowExecutionFromEventBridge"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.collector.function_name

  principal = "events.amazonaws.com"

  source_arn = aws_cloudwatch_event_rule.collector_schedule.arn

}
