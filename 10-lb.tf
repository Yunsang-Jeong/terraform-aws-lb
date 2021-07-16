resource "aws_lb" "this" {
  # Required
  name = join("-", compact([var.lb.load_balancer_type == "application" ? "alb" : "nlb", local.name_tag_middle, var.lb.name]))
  load_balancer_type = var.lb.load_balancer_type
  subnets = var.lb.subnets
  security_groups = var.lb.security_groups

  # Optional
  internal = var.lb.internal
  customer_owned_ipv4_pool = var.lb.customer_owned_ipv4_pool
  drop_invalid_header_fields = var.lb.drop_invalid_header_fields
  enable_cross_zone_load_balancing = var.lb.enable_cross_zone_load_balancing
  enable_deletion_protection = var.lb.enable_deletion_protection
  enable_http2 = var.lb.enable_http2
  idle_timeout = var.lb.idle_timeout
  ip_address_type = var.lb.ip_address_type

  dynamic "access_logs" {
    for_each = var.lb.access_logs == null ? toset([]) : var.lb.access_logs
    content {
      bucket = access_logs.value["bucket"]
      enabled = access_logs.value["enabled"]
      prefix = access_logs.value["prefix"]
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.lb.subnet_mapping == null ? toset([]) : var.lb.subnet_mapping
    content {
      allocation_id = subnet_mapping.value["allocation_id"]
      ipv6_address = subnet_mapping.value["ipv6_address"]
      private_ipv4_address = subnet_mapping.value["private_ipv4_address"]
      subnet_id = subnet_mapping.value["subnet_id"]
    }
  }

  dynamic "timeouts" {
    for_each = var.lb.timeouts == null ? toset([]) : var.lb.timeouts 
    content {
      create = timeouts.value["create"]
      delete = timeouts.value["delete"]
      update = timeouts.value["update"]
    }
  }

  tags = merge(var.global_additional_tag, var.lb.additional_tag, {
    "Name" = join("-", compact([var.lb.load_balancer_type == "application" ? "alb" : "nlb", local.name_tag_middle, var.lb.name]))
  })
}