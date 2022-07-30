# Виртуальные машины для kubernetes

# bastion
resource "yandex_compute_instance" "bastion-vm" {
  name     = "bastion"
  zone     = yandex_vpc_subnet.public-subnet.zone

  resources {
    cores  = (terraform.workspace == "stage") ? 2 : 4
    memory = (terraform.workspace == "stage") ? 2 : 4
    core_fraction = (terraform.workspace == "stage") ? 5 : 100
  }

  boot_disk {
    initialize_params {
      image_id = "fd89ovh4ticpo40dkbvd" # ubuntu
      size     = (terraform.workspace == "stage") ? 50 : 100
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet.id
    nat       = true # для публичного IP-адреса
  }

  scheduling_policy {
    preemptible = (terraform.workspace == "stage") ? true : false # прерываемая
  }

  metadata = {
    ssh-keys = "my_key:${file("~/.ssh/id_rsa_ya.pub")}"
  }
}

# master
resource "yandex_compute_instance" "master-vm" {
  for_each = { for key, val in local.k8s_desc:
               key => val if val["master"] == true }

  name     = each.key
  zone     = yandex_vpc_subnet.private-subnet[each.key].zone

  resources {
    cores  = (terraform.workspace == "stage") ? 2 : 4
    memory = (terraform.workspace == "stage") ? 2 : 4
    core_fraction = (terraform.workspace == "stage") ? 5 : 100
  }

  boot_disk {
    initialize_params {
      image_id = "fd89ovh4ticpo40dkbvd" # ubuntu
      size     = (terraform.workspace == "stage") ? 50 : 100
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet[each.key].id
    nat       = false
  }

  scheduling_policy {
    preemptible = (terraform.workspace == "stage") ? true : false # прерываемая
  }

  metadata = {
    ssh-keys = "my_key:${file("~/.ssh/id_rsa_ya.pub")}"
  }
}

# worker
resource "yandex_compute_instance" "worker-vm" {
  for_each = { for key, val in local.k8s_desc:
               key => val if val["master"] == false }

  name     = each.key
  zone     = yandex_vpc_subnet.private-subnet[each.key].zone

  resources {
    cores  = (terraform.workspace == "stage") ? 2 : 4
    memory = (terraform.workspace == "stage") ? 2 : 4
    core_fraction = (terraform.workspace == "stage") ? 5 : 100
  }

  boot_disk {
    initialize_params {
      image_id = "fd89ovh4ticpo40dkbvd" # ubuntu
      size     = (terraform.workspace == "stage") ? 100 : 200
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet[each.key].id
    nat       = false
  }

  scheduling_policy {
    preemptible = (terraform.workspace == "stage") ? true : false # прерываемая
  }

  metadata = {
    ssh-keys = "my_key:${file("~/.ssh/id_rsa_ya.pub")}"
  }
}