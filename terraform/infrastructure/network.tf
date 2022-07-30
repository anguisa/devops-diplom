# VPC
resource "yandex_vpc_network" "vpc" {
  name = "vpc-network"
}

# Публичная подсеть
resource "yandex_vpc_subnet" "public-subnet" {
  name           = local.public_subnet_desc["subnet_name"]
  zone           = local.public_subnet_desc["zone"]
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = local.public_subnet_desc["v4_cidr_blocks"]
}

# NAT instance для доступа в интернет
resource "yandex_compute_instance" "nat-vm" {
  name = "nat-vm-instance"

  resources {
    cores  = 2
    memory = 2
    core_fraction = (terraform.workspace == "stage") ? 5 : 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1" # nat-instance-ubuntu
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet.id
    nat       = true # для публичного адреса
  }

  metadata = {
    ssh-keys = "my_key:${file("~/.ssh/id_rsa_ya.pub")}"
  }
}

# Таблица маршрутизации
resource "yandex_vpc_route_table" "route-table-nat" {
  network_id = yandex_vpc_network.vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0" # весь трафик
    next_hop_address   = yandex_compute_instance.nat-vm.network_interface[0].ip_address # направляется на NAT инстанс
  }
}

# Приватные подсети
resource "yandex_vpc_subnet" "private-subnet" {
  for_each       = local.k8s_desc
  name           = each.value["subnet_name"]
  zone           = each.value["zone"]
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = each.value["v4_cidr_blocks"]
  route_table_id = yandex_vpc_route_table.route-table-nat.id # привязываем таблицу маршрутизации
}
