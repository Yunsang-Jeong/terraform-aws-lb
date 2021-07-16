type = "application"
internal = false
subnet_ids = [ ]
security_group_ids = [ ]
target_groups = [{
  identifier = "web"
  port       = 80
  protocol   = "HTTP"
  health_check_port = "traffic-port"
  health_check_path = "/"
}]
listeners = [{
  port     = 80
  protocol = "HTTP"
  default_action = [{
    identifier              = "web-80"
    type                    = "forward"
    target_group_identifier = "web"
  }]
}]