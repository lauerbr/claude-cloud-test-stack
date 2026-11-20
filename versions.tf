# A throwaway stack the Sandbox runner plans and applies, so the runner's apply path is exercised
# where nothing matters before it ever applies a production stack. See README.md.

terraform {
  required_version = "1.17.2" # what the runner installs (aws-organizations: claude-cloud-apply/variables.tf)

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.71"
    }
  }

  # Bucket and key in backend.sandbox.hcl; the bucket is created by aws-organizations
  # (claude-cloud-apply/main.tf).
  backend "s3" {}
}

provider "aws" {
  region              = "us-east-1"
  allowed_account_ids = ["891498120624"]

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Repo      = "claude-cloud-test-stack"
    }
  }
}
