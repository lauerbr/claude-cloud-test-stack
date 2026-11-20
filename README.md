# claude-cloud-test-stack

A throwaway Terraform stack in the Sandbox account (891498120624) that the Claude cloud runner
(`claude-cloud-apply/` in `lauerbr/aws-organizations`) plans and applies. It exists so every runner
outcome can be tested on `main` without touching a production stack. It holds one free SSM
parameter.

## Why this is a separate, public repository

The runner clones a private repository with a read-only deploy key it keeps in that stack's AWS
account. This repository is public instead, so the Sandbox runner clones it anonymously and the
Sandbox account holds no GitHub credential at all. Nothing here may be secret.

`main` is protected by a ruleset (no direct pushes, no force-pushes, no deletion), because what
merges here is what the Sandbox runner applies. The runner applies it under a policy that reaches
only this stack's one parameter and its state.

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
