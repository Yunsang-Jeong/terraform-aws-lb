##########
# Shared
variable "name_tag_convention" {
  description = "Name tag convention"
  type = object({
    project_name   = string
    stage          = string
  })
}

variable "global_additional_tag" {
  description = "Additional tags for all resources created within a Terraform, e.g. Enviroment, System"
  type        = map(string)
  default     = {}
}
##########


##########
# LB
variable "lb" {
  description = "Name tag convention"
  type = object(
    {
      # Required
      name = string
      load_balancer_type = string
      subnets = set(string)
      security_groups = set(string)
      # Optional
      internal = optional(bool)
      customer_owned_ipv4_pool = optional(string)
      drop_invalid_header_fields = optional(bool)
      enable_cross_zone_load_balancing = optional(bool)
      enable_deletion_protection = optional(bool)
      enable_http2 = optional(bool)
      idle_timeout = optional(number)
      ip_address_type = optional(string)
      access_logs = optional(set(object(
        {
          bucket  = string
          enabled = optional(bool)
          prefix  = optional(string)
        }
      )))
      subnet_mapping = optional(set(object(
        {
          subnet_id            = optional(string)
          allocation_id        = optional(string)
          ipv6_address         = optional(string)
          private_ipv4_address = optional(string)
        }
      )))
      timeouts = optional(set(object(
        {
          create = string
          delete = string
          update = string
        }
      )))
      # Shared
      additional_tag        = optional(map(string))
    }
  )
}
##########


##########
# Target groups
variable "target_groups" {
  description = "The list of target group"
  type = list(object(
    {
      # Required
      identifier                         = string
      # Optional
      port                               = optional(number)
      vpc_id                             = optional(string)
      deregistration_delay               = optional(number)
      lambda_multi_value_headers_enabled = optional(bool)
      load_balancing_algorithm_type      = optional(bool)
      preserve_client_ip                 = optional(string)
      protocol                           = optional(string)
      protocol_version                   = optional(string)
      proxy_protocol_v2                  = optional(bool)
      slow_start                         = optional(number)
      target_type                        = optional(string)
      health_check = optional(object(
        {
          path                = string
          matcher             = optional(string)
          enabled             = optional(bool)
          protocol            = optional(string)
          port                = optional(string)
          interval            = optional(number)
          timeout             = optional(number)
          healthy_threshold   = optional(number)
          unhealthy_threshold = optional(number)
        }
      ))
      stickiness = optional(object(
        {
          type            = string
          enabled         = optional(bool)
          cookie_duration = optional(number)
        }
      ))
      # Shared
      additional_tag        = optional(map(string))
    }
))
  default = []
}
##########


##########
# Listener
variable "listeners" {
  description = "The list of listener"
  type = list(object(
    {
      port            = optional(number)
      protocol        = optional(string)
      ssl_policy      = optional(string)
      certificate_arn = optional(string)
      default_action = list(object(
        {
          identifier              = string
          type                    = string
          order                   = optional(number)
          target_group_arn        = optional(string)
          target_group_identifier = optional(string)
          authenticate_cognito = optional(object(
            {
              authentication_request_extra_params = optional(map(string))
              on_unauthenticated_request          = optional(string)
              scope                               = optional(string)
              session_cookie_name                 = optional(string)
              session_timeout                     = optional(number)
              user_pool_arn                       = string
              user_pool_client_id                 = string
              user_pool_domain                    = string
            }
          ))
          authenticate_oidc = optional(object(
            {
              authentication_request_extra_params = optional(map(string))
              authorization_endpoint              = string
              client_id                           = string
              client_secret                       = string
              issuer                              = string
              on_unauthenticated_request          = optional(string)
              scope                               = optional(string)
              session_cookie_name                 = optional(string)
              session_timeout                     = optional(number)
              token_endpoint                      = string
              user_info_endpoint                  = string
            }
          ))
          fixed_response = optional(object(
            {
              content_type = string
              message_body = optional(string)
              status_code  = optional(string)
            }
          ))
          forward = optional(object(
            {
              stickiness = optional(object(
                {
                  duration = number
                  enabled  = optional(bool)
                }
              ))
              target_group = set(object(
                {
                  arn    = optional(string)
                  target_group_identifier = optional(string)
                  weight = optional(number)
                }
              ))
            }
          ))
          redirect = optional(object(
            {
              host        = optional(string)
              path        = optional(string)
              port        = optional(string)
              protocol    = optional(string)
              query       = optional(string)
              status_code = string
            }
          ))
        }
      ))
    }
  ))
}
##########