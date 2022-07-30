provider "yandex" {
  cloud_id  = local.cloud_id[terraform.workspace]
  folder_id = local.folder_id[terraform.workspace]
  zone      = local.default_zone[terraform.workspace]
  #  token     = "<OAuth или статический ключ сервисного аккаунта>" # задаётся через переменную окружения YC_TOKEN
}
