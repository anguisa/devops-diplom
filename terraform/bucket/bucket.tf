# Бакет для хранения состояний Terraform (имя должно быть уникальным среди всех)
resource "yandex_storage_bucket" "terraform-states-olga-bucket" {
  access_key = yandex_iam_service_account_static_access_key.bucket-sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.bucket-sa-static-key.secret_key
  bucket     = "terraform-states-olga-bucket"
  folder_id  = local.folder_id
  acl        = "private"
}