output "password" {
value = module.iam_user.password
#nonsensitive = true
}


output "access_key_id" {
value = module.iam_user.access_key_id
}



output "secret_access_key" {
value = module.iam_user.secret_access_key
#nonsensitive = true
}