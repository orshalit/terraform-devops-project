#!/bin/bash

# The parent directory where your Terraform configurations are located. 
# Use '.' to represent the current directory if the script is run at the root of the Terraform configurations.
PARENT_DIR="."

# Find all Terraform directories
find "$PARENT_DIR" -type f -name '*.tf' -exec dirname {} \; | sort -u | while read -r dir; do
    echo "Running terraform fmt in directory: $dir"
    (cd "$dir" && terraform fmt)
done

echo "Terraform fmt has been run on all .tf files within the $PARENT_DIR directory and subdirectories."