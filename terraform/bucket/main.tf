provider "yandex" {
  cloud_id  = local.cloud_id
  folder_id = local.folder_id
  zone      = local.zone
  #  token     = "<OAuth или статический ключ сервисного аккаунта>" # задаётся через переменную окружения YC_TOKEN
}