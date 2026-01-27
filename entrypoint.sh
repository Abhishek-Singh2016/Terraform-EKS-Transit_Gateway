#!/bin/sh
set -e

echo "Starting Terraform Runtime Initialization..."

# 1. Initialize Terraform
# -input=false ensures it doesn't hang waiting for user prompts
terraform init -input=false

# 2. Execute the user's command (plan, apply, etc.)
# "$@" passes all arguments from 'docker run' to this final command
exec terraform "$@"