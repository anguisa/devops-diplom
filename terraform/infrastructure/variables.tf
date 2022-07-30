locals {
  folder_id = {
    stage = "b1gcefcbnh0ok32bkvif"
    prod  = "b1gcefcbnh0ok32bkvif1"
  }
  cloud_id = {
    stage = "b1go6ie337pf2l92gurj"
    prod  = "b1go6ie337pf2l92gurj1"
  }
  default_zone = {
    stage = "ru-central1-a"
    prod  = "ru-central1-a"
  }
  # настройки виртуальных машин и подсетей для kubernetes в зависимости от workspace
  # ноды - в приватных подсетях, доступ по ssh - через бастион в публичной подсети
  k8s_desc_map = {
    stage = { # ключ - workspace
      cp1 = {
        subnet_name    = "subnet1" # имя подсети
        v4_cidr_blocks = ["192.168.10.0/24"] # cidr подсети
        zone           = "ru-central1-a" # зона доступности
        master         = true
      }
      node1 = {
        subnet_name    = "subnet2"
        v4_cidr_blocks = ["192.168.20.0/24"]
        zone           = "ru-central1-b"
        master         = false
      }
      node2 = {
        subnet_name    = "subnet3"
        v4_cidr_blocks = ["192.168.30.0/24"]
        zone           = "ru-central1-c"
        master         = false
      }
    }
    prod = {
      cp1 = {
        subnet_name    = "subnet1"
        v4_cidr_blocks = ["192.168.10.0/24"]
        zone           = "ru-central1-a"
        master         = true
      }
      cp2 = {
        subnet_name    = "subnet2"
        v4_cidr_blocks = ["192.168.20.0/24"]
        zone           = "ru-central1-b"
        master         = true
      }
      cp3 = {
        subnet_name    = "subnet3"
        v4_cidr_blocks = ["192.168.30.0/24"]
        zone           = "ru-central1-c"
        master         = true
      }
      node1 = {
        subnet_name    = "subnet4"
        v4_cidr_blocks = ["192.168.40.0/24"]
        zone           = "ru-central1-a"
        master         = false
      }
      node2 = {
        subnet_name    = "subnet5"
        v4_cidr_blocks = ["192.168.50.0/24"]
        zone           = "ru-central1-b"
        master         = false
      }
      node3 = {
        subnet_name    = "subnet6"
        v4_cidr_blocks = ["192.168.60.0/24"]
        zone           = "ru-central1-c"
        master         = false
      }
    }
  }
  # настройки публичной подсети для бастиона и NAT
  public_subnet_desc_map = {
    stage = {
      subnet_name    = "subnet0"
      v4_cidr_blocks = ["192.168.5.0/24"]
      zone           = "ru-central1-a"
    }
    prod = {
      subnet_name    = "subnet0"
      v4_cidr_blocks = ["192.168.5.0/24"]
      zone           = "ru-central1-a"
    }
  }
  k8s_desc = local.k8s_desc_map[terraform.workspace]
  public_subnet_desc = local.public_subnet_desc_map[terraform.workspace]
}