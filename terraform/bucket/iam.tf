# Сервисный аккаунт для работы с бакетом
resource "yandex_iam_service_account" "bucket-sa" {
  folder_id   = local.folder_id
  name        = "bucket-sa"
  description = "service account to manage infrastructure"
}

# Права на редактирование бакетов и объектов в каталоге
resource "yandex_resourcemanager_folder_iam_member" "bucket-sa-editor" {
  folder_id = local.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-sa.id}"
}

# Статический ключ доступа
resource "yandex_iam_service_account_static_access_key" "bucket-sa-static-key" {
  service_account_id = yandex_iam_service_account.bucket-sa.id
  description        = "static access key for object storage"
}