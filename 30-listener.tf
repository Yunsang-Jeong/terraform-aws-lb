resource "aws_lb_listener" "this" {
  for_each = { for listener in var.listeners : "${listener.protocol}-${listener.port}" => listener }

  load_balancer_arn = aws_lb.this.arn
  certificate_arn = each.value.certificate_arn
  port = each.value.port
  protocol = each.value.protocol
  ssl_policy = each.value.ssl_policy

  dynamic "default_action" {
    for_each = { for act in each.value.default_action : act.identifier => act }
    content {
      type             = default_action.value["type"]
      order            = default_action.value["order"]
      target_group_arn = default_action.value["type"] != "forward" ? null : (
        default_action.value["target_group_identifier"] == null ? 
          default_action.value["target_group_arn"] : 
          lookup(aws_lb_target_group.this, default_action.value["target_group_identifier"]).arn
      )

      dynamic "authenticate_cognito" {
        for_each = default_action.value.authenticate_cognito == null ? toset([]) : toset([default_action.value.authenticate_cognito])
        content {
          authentication_request_extra_params = authenticate_cognito.value["authentication_request_extra_params"]
          on_unauthenticated_request = authenticate_cognito.value["on_unauthenticated_request"]
          scope = authenticate_cognito.value["scope"]
          session_cookie_name = authenticate_cognito.value["session_cookie_name"]
          session_timeout = authenticate_cognito.value["session_timeout"]
          user_pool_arn = authenticate_cognito.value["user_pool_arn"]
          user_pool_client_id = authenticate_cognito.value["user_pool_client_id"]
          user_pool_domain = authenticate_cognito.value["user_pool_domain"]
        }
      }

      dynamic "authenticate_oidc" {
        for_each = default_action.value.authenticate_oidc == null ? toset([]) : toset([default_action.value.authenticate_oidc])
        content {
          authentication_request_extra_params = authenticate_oidc.value["authentication_request_extra_params"]
          authorization_endpoint = authenticate_oidc.value["authorization_endpoint"]
          client_id = authenticate_oidc.value["client_id"]
          client_secret = authenticate_oidc.value["client_secret"]
          issuer = authenticate_oidc.value["issuer"]
          on_unauthenticated_request = authenticate_oidc.value["on_unauthenticated_request"]
          scope = authenticate_oidc.value["scope"]
          session_cookie_name = authenticate_oidc.value["session_cookie_name"]
          session_timeout = authenticate_oidc.value["session_timeout"]
          token_endpoint = authenticate_oidc.value["token_endpoint"]
          user_info_endpoint = authenticate_oidc.value["user_info_endpoint"]
        }
      }

      dynamic "fixed_response" {
        for_each = default_action.value.fixed_response == null ? toset([]) : toset([default_action.value.fixed_response])
        content {
          content_type = fixed_response.value["content_type"]
          message_body = fixed_response.value["message_body"]
          status_code = fixed_response.value["status_code"]
        }
      }

      dynamic "forward" {
        for_each = default_action.value.forward == null ? toset([]) : (
          length(default_action.value.forward.target_group) < 2 ? 
            toset([]) : 
            toset([default_action.value.forward])
        )
        content {
          dynamic "stickiness" {
            for_each = forward.value.stickiness == null ? toset([]) : toset([forward.value.stickiness])
            content {
              duration = stickiness.value["duration"]
              enabled = stickiness.value["enabled"]
            }
          }
          dynamic "target_group" {
            for_each = forward.value.target_group == null ? toset([]) : forward.value.target_group
            content {
              arn = target_group.value["target_group_identifier"] == null ? target_group.value["arn"] : lookup(aws_lb_target_group.this, target_group.value["target_group_identifier"]).arn
              weight = target_group.value["weight"]
            }
          }
        }
      }

      dynamic "redirect" {
        for_each = default_action.value.redirect == null ? toset([]) : toset([default_action.value.redirect])
        content {
          host = redirect.value["host"]
          path = redirect.value["path"]
          port = redirect.value["port"]
          protocol = redirect.value["protocol"]
          query = redirect.value["query"]
          status_code = redirect.value["status_code"]
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}