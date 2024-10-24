# Output: Show the generated random string
output "random_string_value" {
  description = "The generated random string"
  value       = random_string.example[*].result
}