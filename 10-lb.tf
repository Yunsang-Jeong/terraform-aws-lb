resource "aws_lb" "this" {
  # Required
  name = join("-", compact(["alb", local.name_tag_middle, var.alb.name]))
  load_balancer_type = var.alb.load_balancer_type
  subnets = var.alb.subnets
  security_groups = var.alb.security_groups

  # Optional
  internal = var.alb.internal
  customer_owned_ipv4_pool = var.alb.customer_owned_ipv4_pool
  drop_invalid_header_fields = var.alb.drop_invalid_header_fields
  enable_cross_zone_load_balancing = var.alb.enable_cross_zone_load_balancing
  enable_deletion_protection = var.alb.enable_deletion_protection
  enable_http2 = var.alb.enable_http2
  idle_timeout = var.alb.idle_timeout
  ip_address_type = var.alb.ip_address_type

  dynamic "access_logs" {
    for_each = var.alb.access_logs == null ? toset([]) : var.alb.access_logs
    content {
      bucket = access_logs.value["bucket"]
      enabled = access_logs.value["enabled"]
      prefix = access_logs.value["prefix"]
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.alb.subnet_mapping == null ? toset([]) : var.alb.subnet_mapping
    content {
      allocation_id = subnet_mapping.value["allocation_id"]
      ipv6_address = subnet_mapping.value["ipv6_address"]
      private_ipv4_address = subnet_mapping.value["private_ipv4_address"]
      subnet_id = subnet_mapping.value["subnet_id"]
    }
  }

  dynamic "timeouts" {
    for_each = var.alb.timeouts == null ? toset([]) : var.alb.timeouts 
    content {
      create = timeouts.value["create"]
      delete = timeouts.value["delete"]
      update = timeouts.value["update"]
    }
  }

  tags = merge(var.global_additional_tag, var.alb.additional_tag, {
    "Name" = join("-", compact(["alb", local.name_tag_middle, var.alb.name]))
  })
}