output "alb" {
  description = "alb"
  value       = aws_lb.this
}

output "target_groups" {
  description = "target_groups"
  value       = aws_lb_target_group.this
}

output "listeners" {
  description = "listeners"
  value       = aws_lb_listener.this
}