provider "vsphere" {
	vsphere_server        = "${var.vsphere_vcenter}"
    user                  = "${var.vsphere_username}"
    password              = "${var.vsphere_password}"
    allow_unverified_ssl = true
}

locals {
    ambientefull  = {
        dev = "Desenvolvimento",
        hmg = "Homologacao",
        prd = "Producao"
    }
    folder = "MONGERAL_AEGON/${local.ambientefull["${var.ambiente}"]}/${var.nomemodulo}/${var.nomemodulo}-${upper(var.ambiente)}"
}

data "vsphere_datacenter" "dc" {
    name = "${var.datacenter}"
}
data "vsphere_datastore" "datastore" {
    name          = "SC:ESIMOS01"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_compute_cluster" "cluster" {
    name          = "Dell FX2"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_network" "network" {
    name          = "${var.network}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_virtual_machine" "template" {
    name          = "${var.vm_template}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
resource "random_string" "rd_name" {
  length  = 5
  lower   = true
  number  = true
  upper   = false
  special = false
}
resource "vsphere_virtual_machine" "vm" {
    count               = "${var.qtd_vm}"
    name                = "${lower("${var.seguradora}${random_string.rd_name.result}${var.ambiente}")}"
    resource_pool_id    = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
    datastore_id        = "${data.vsphere_datastore.datastore.id}"
    
    num_cpus            = "${var.vm_num_cpus}"
    memory              = "${var.vm_memory}"
    guest_id            = "${data.vsphere_virtual_machine.template.guest_id}"

    scsi_type           = "${data.vsphere_virtual_machine.template.scsi_type}"

    folder              = "${local.folder}"

    annotation          = "Criado em: ${timestamp()} Seguradora: ${var.seguradora} Ambiente: ${var.ambiente} Versao: ${var.versao} ${var.vm_annotation}"

    network_interface {
        network_id   = "${data.vsphere_network.network.id}"
        adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
    }

    disk {
        label            = "disk0"
        size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
        eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
        thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
        unit_number       = "0"
    }

    disk {
        label            = "disk1"
        size             = "${data.vsphere_virtual_machine.template.disks.1.size}"
        eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.1.eagerly_scrub}"
        thin_provisioned = "${data.vsphere_virtual_machine.template.disks.1.thin_provisioned}"
        unit_number      = "1"
    }

    disk {
        label            = "disk2"
        size             = "${data.vsphere_virtual_machine.template.disks.2.size}"
        eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.2.eagerly_scrub}"
        thin_provisioned = "${data.vsphere_virtual_machine.template.disks.2.thin_provisioned}"
        unit_number      = "2"
    }
  
    clone {
        template_uuid = "${data.vsphere_virtual_machine.template.id}"

        customize {
            windows_options {
                computer_name           = "${lower("${var.seguradora}${random_string.rd_name.result}${var.ambiente}")}"  
                #join_domain             = "${var.vm_domain}"
                #domain_admin_user       = "${var.vm_domain_usr}"
                #domain_admin_password   = "${var.vm_domain_pws}"
                #time_zone               = 65
                #auto_logon              = true
                #run_once_command_list   = ""
            }

            network_interface {}
        }
    }
}