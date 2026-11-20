# One free resource, so each runner outcome can be produced by a one-line change on main:
#   change `marker`            -> an update; mode=apply should apply it
#   remove the parameter       -> a delete; the gate should stop with PlanDeletes
#   add the commented role     -> the Sandbox guard should stop with PlanForbidden
# A standard-tier SSM String parameter costs nothing.

variable "marker" {
  description = "Change this on main to give the runner something to apply."
  type        = string
  default     = "v2"
}


# Uncomment on main to test the guard refusal (the Sandbox runner refuses any IAM role change):
#
# resource "aws_iam_role" "guard_test" {
#   name               = "claude-cloud-test-stack-guard-test"
#   assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [] })
# }
