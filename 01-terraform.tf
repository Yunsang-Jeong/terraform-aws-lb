terraform {
  required_version = ">= 0.15.0"
  experiments      = [module_variable_optional_attrs]

  # https://www.tfwriter.com/aws/r/aws_lb.html
  # https://www.tfwriter.com/aws/r/aws_lb_target_group.html
  required_providers {
    aws = ">= 3.35.0"
  }
}