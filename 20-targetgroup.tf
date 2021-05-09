resource "aws_lb_target_group" "this" {
  for_each = { for tg in var.target_groups : tg.identifier  => tg }
  
  # Required
  vpc_id = each.value.vpc_id
  target_type = each.value.target_type
  name = join("-", compact([local.project_name, local.stage, each.key, each.value.port]))
  port = each.value.port

  # Optional
  protocol = each.value.protocol
  protocol_version = each.value.protocol_version
  load_balancing_algorithm_type = each.value.load_balancing_algorithm_type
  proxy_protocol_v2 = each.value.proxy_protocol_v2
  deregistration_delay = each.value.deregistration_delay
  lambda_multi_value_headers_enabled = each.value.lambda_multi_value_headers_enabled
  preserve_client_ip = each.value.preserve_client_ip
  slow_start = each.value.slow_start

  dynamic "health_check" {
    for_each = each.value.health_check == null ? toset([]) : each.value.health_check
    content {
      enabled = health_check.value["enabled"]
      healthy_threshold = health_check.value["healthy_threshold"]
      interval = health_check.value["interval"]
      matcher = health_check.value["matcher"]
      path = health_check.value["path"]
      port = health_check.value["port"]
      protocol = health_check.value["protocol"]
      timeout = health_check.value["timeout"]
      unhealthy_threshold = health_check.value["unhealthy_threshold"]
    }
  }

  dynamic "stickiness" {
    for_each = each.value.stickiness == null ? toset([]) : each.value.stickiness
    content {
      cookie_duration = stickiness.value["cookie_duration"]
      enabled = stickiness.value["enabled"]
      type = stickiness.value["type"]
    }
  }

  tags = merge(var.global_additional_tag, var.alb.additional_tag, {
    "Name" = join("-", compact([local.project_name, local.stage, each.key, each.value.port]))
  })
}