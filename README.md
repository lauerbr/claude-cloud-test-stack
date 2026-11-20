# claude-cloud-test-stack

A throwaway Terraform stack in the Sandbox account (891498120624) that the Claude cloud runner
(`claude-cloud-apply/` in `lauerbr/aws-organizations`) plans and applies. It exists so every runner
outcome can be tested on `main` without touching a production stack. It holds one free SSM
parameter.

## Why this is a separate, public repository

The runner's source build clones its stacks through a GitHub CodeConnections connection, and every
AWS account's connection shares one installation of the AWS Connector GitHub App, which has write
access to every repository it is installed on. Giving the Sandbox account a connection would let
anyone with admin there mint tokens for those repositories. So the Sandbox runner has no
connection at all and clones this repository anonymously. Nothing here may be secret.

## Running the tests

Run it through the Sandbox runner API (in `aws-organizations`:
`terraform -chdir=claude-cloud-apply output -json endpoints`, key `sandbox`), with stack
`claude-cloud-test`. Each test is a one-line change merged to `main` here:

| Change on `main` | `mode: apply` should end with |
|---|---|
| none (after the first apply) | `no-changes` |
| change `marker`'s default | `applied`; the parameter's value changes |
| delete `aws_ssm_parameter.marker` | `PlanDeletes`; nothing is deleted |
| uncomment `aws_iam_role.guard_test` | `PlanForbidden`; nothing is created |

The first `mode: apply` creates the parameter. The runner applies only `main`, so these changes go
through a pull request like any other.

The state bucket, `claude-cloud-test-state-891498120624-us-east-1-an`, is created and owned by
`aws-organizations`, not by this stack. To remove the stack, delete the parameter by hand, or
locally with `terraform destroy` against `backend.sandbox.hcl`. The runner never applies deletions.
