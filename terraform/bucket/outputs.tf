# идентификатор статического ключа (для backend)
output "access_key" {
  value = yandex_iam_service_account_static_access_key.bucket-sa-static-key.access_key
}

# секретный ключ (для backend); значение будет в файле terraform.tfstate
output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.bucket-sa-static-key.secret_key
  sensitive = true
}