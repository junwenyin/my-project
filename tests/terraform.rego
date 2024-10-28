package terraform.policy.resource_change_limits

import rego.v1

default authz := false

# Define thresholds for each type of change
max_creates = 10
max_updates = 0
max_deletes = 0

authz if {
	resource_change_summary.total_updated <= max_updates
	resource_change_summary.total_deleted <= max_deletes
	resource_change_summary.total_created <= max_creates
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

deny contains msg if {
  total_created > max_creates
  msg := sprintf("Too many resources to create: %d. Limit is %d.", [total_created, max_creates])
}

deny contains msg if {
  total_updated > max_updates
  msg := sprintf("Too many resources to update: %d. Limit is %d.", [total_updated, max_updates])
}

deny contains msg if {
  total_deleted > max_deletes
  msg := sprintf("Too many resources to delete: %d. Limit is %d.", [total_deleted, max_deletes])
}
