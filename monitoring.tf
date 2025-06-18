resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/app"
  retention_in_days = 14
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "HighCPU"
  comparison_operator  = "GreaterThanThreshold"
  evaluation_periods   = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors high CPU utilization"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
  alarm_actions = []
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "main-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x    = 0
        y    = 0
        width = 12
        height = 6
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.app.name ]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "EC2 ASG CPU Utilization"
        }
      }
    ]
  })
}