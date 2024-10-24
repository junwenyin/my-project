# Define the input as the Terraform plan JSON
package terraform.analysis
import rego.v1

default authz := false

authz if {
	resource_change_summary.total_updated == 0
	resource_change_summary.total_deleted == 0
	resource_change_summary.total_created > 0
}

# Rule to identify created resources
created_resources contains resource if {
    input.resource_changes[_].change.actions[_] == "create"
    resource := input.resource_changes[_].address
}

# Rule to identify updated resources
updated_resources contains resource if {
    input.resource_changes[_].change.actions[_] == "update"
    resource := input.resource_changes[_].address
}

# Rule to identify deleted resources
deleted_resources contains resource if {
    input.resource_changes[_].change.actions[_] == "delete"
    resource := input.resource_changes[_].address
}

# Rule to provide the summary of resource changes
resource_change_summary := {
    "total_created": total_created,
    "total_updated": total_updated,
    "total_deleted": total_deleted
}

# Using the built-in count function but with new names for results
total_created := count(created_resources)
total_updated := count(updated_resources)
total_deleted := count(deleted_resources)


