resource "aws_cloudwatch_event_rule" "collector_schedule" {

  name = "iaqap-dev-collector-schedule"

  description = "Run collector every 15 minutes"

  schedule_expression = "rate(15 minutes)"

}
