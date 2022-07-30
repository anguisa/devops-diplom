terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-states-olga-bucket"
    region     = "ru-central1"
    key        = "devops/terraform.tfstate" # путь к файлу состояний в бакете
    #    access_key = "<идентификатор статического ключа>" # переменная окружения YC_ACCESS_KEY_ID
    #    secret_key = "<секретный ключ>" # переменная окружения YC_SECRET_ACCESS_KEY

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}