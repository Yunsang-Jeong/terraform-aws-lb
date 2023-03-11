# Overview

AWS Load-Balancer를 생성하는 모듈입니다. 하단의 내용은 `terraform-docs`에 의해 생성되었습니다.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_global_additional_tag"></a> [global\_additional\_tag](#input\_global\_additional\_tag) | Additional tags for all resources created within a Terraform, e.g. Enviroment, System | `map(string)` | `{}` | no |
| <a name="input_lb"></a> [lb](#input\_lb) | Name tag convention | <pre>object(<br>    {<br>      # Required<br>      name = string<br>      load_balancer_type = string<br>      subnets = set(string)<br>      security_groups = set(string)<br>      # Optional<br>      internal = optional(bool)<br>      customer_owned_ipv4_pool = optional(string)<br>      drop_invalid_header_fields = optional(bool)<br>      enable_cross_zone_load_balancing = optional(bool)<br>      enable_deletion_protection = optional(bool)<br>      enable_http2 = optional(bool)<br>      idle_timeout = optional(number)<br>      ip_address_type = optional(string)<br>      access_logs = optional(set(object(<br>        {<br>          bucket  = string<br>          enabled = optional(bool)<br>          prefix  = optional(string)<br>        }<br>      )))<br>      subnet_mapping = optional(set(object(<br>        {<br>          subnet_id            = optional(string)<br>          allocation_id        = optional(string)<br>          ipv6_address         = optional(string)<br>          private_ipv4_address = optional(string)<br>        }<br>      )))<br>      timeouts = optional(set(object(<br>        {<br>          create = string<br>          delete = string<br>          update = string<br>        }<br>      )))<br>      # Shared<br>      additional_tag        = optional(map(string))<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | The list of listener | <pre>list(object(<br>    {<br>      port            = optional(number)<br>      protocol        = optional(string)<br>      ssl_policy      = optional(string)<br>      certificate_arn = optional(string)<br>      default_action = list(object(<br>        {<br>          identifier              = string<br>          type                    = string<br>          order                   = optional(number)<br>          target_group_arn        = optional(string)<br>          target_group_identifier = optional(string)<br>          authenticate_cognito = optional(object(<br>            {<br>              authentication_request_extra_params = optional(map(string))<br>              on_unauthenticated_request          = optional(string)<br>              scope                               = optional(string)<br>              session_cookie_name                 = optional(string)<br>              session_timeout                     = optional(number)<br>              user_pool_arn                       = string<br>              user_pool_client_id                 = string<br>              user_pool_domain                    = string<br>            }<br>          ))<br>          authenticate_oidc = optional(object(<br>            {<br>              authentication_request_extra_params = optional(map(string))<br>              authorization_endpoint              = string<br>              client_id                           = string<br>              client_secret                       = string<br>              issuer                              = string<br>              on_unauthenticated_request          = optional(string)<br>              scope                               = optional(string)<br>              session_cookie_name                 = optional(string)<br>              session_timeout                     = optional(number)<br>              token_endpoint                      = string<br>              user_info_endpoint                  = string<br>            }<br>          ))<br>          fixed_response = optional(object(<br>            {<br>              content_type = string<br>              message_body = optional(string)<br>              status_code  = optional(string)<br>            }<br>          ))<br>          forward = optional(object(<br>            {<br>              stickiness = optional(object(<br>                {<br>                  duration = number<br>                  enabled  = optional(bool)<br>                }<br>              ))<br>              target_group = set(object(<br>                {<br>                  arn    = optional(string)<br>                  target_group_identifier = optional(string)<br>                  weight = optional(number)<br>                }<br>              ))<br>            }<br>          ))<br>          redirect = optional(object(<br>            {<br>              host        = optional(string)<br>              path        = optional(string)<br>              port        = optional(string)<br>              protocol    = optional(string)<br>              query       = optional(string)<br>              status_code = string<br>            }<br>          ))<br>        }<br>      ))<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_name_tag_convention"></a> [name\_tag\_convention](#input\_name\_tag\_convention) | Name tag convention | <pre>object({<br>    project_name   = string<br>    stage          = string<br>  })</pre> | n/a | yes |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | The list of target group | <pre>list(object(<br>    {<br>      # Required<br>      identifier                         = string<br>      # Optional<br>      port                               = optional(number)<br>      vpc_id                             = optional(string)<br>      deregistration_delay               = optional(number)<br>      lambda_multi_value_headers_enabled = optional(bool)<br>      load_balancing_algorithm_type      = optional(bool)<br>      preserve_client_ip                 = optional(string)<br>      protocol                           = optional(string)<br>      protocol_version                   = optional(string)<br>      proxy_protocol_v2                  = optional(bool)<br>      slow_start                         = optional(number)<br>      target_type                        = optional(string)<br>      health_check = optional(object(<br>        {<br>          path                = string<br>          matcher             = optional(string)<br>          enabled             = optional(bool)<br>          protocol            = optional(string)<br>          port                = optional(string)<br>          interval            = optional(number)<br>          timeout             = optional(number)<br>          healthy_threshold   = optional(number)<br>          unhealthy_threshold = optional(number)<br>        }<br>      ))<br>      stickiness = optional(object(<br>        {<br>          type            = string<br>          enabled         = optional(bool)<br>          cookie_duration = optional(number)<br>        }<br>      ))<br>      # Shared<br>      additional_tag        = optional(map(string))<br>    }<br>))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb"></a> [lb](#output\_lb) | lb |
| <a name="output_listeners"></a> [listeners](#output\_listeners) | listeners |
| <a name="output_target_groups"></a> [target\_groups](#output\_target\_groups) | target\_groups |

## Example
```hcl
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
```
<!-- END_TF_DOCS -->