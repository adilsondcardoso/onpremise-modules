variable "vsphere_vcenter" {
    description = "(Required) Nome do servidor vCenter para operações da API do vSphere."
}
variable "vsphere_username" {
    description = "(Required) Usuário para vSphere API."
}
variable "vsphere_password" {
    description = "(Required) Senha do usuário para vSphere API."
}
variable "datacenter" {
    description = "(Required) Nome do datacenter. (e.g Level 3 / Matriz / DMZ)"
}
variable "network" {
    description = "(Optional) Nome da rede."
    default     = "dpgServidores"
}
variable "vm_template" {
    description = "(Optional) Template do SO usado na VM. "
    default     = "2016-Core-Mtz"
}
variable "vm_num_cpus" {
    description = "(Optional) Número de CPU."
    default     = "2"
}
variable "vm_memory" {
    description = "(Optional) Total de mémoria em MB. (e.g. 1GB = 1024)"
    default     = "1024"
}

variable "qtd_vm" {
    description = "(Optional) Quantidade de máquina a ser criada."
    default     = "1"
}

variable "seguradora" {
    description = "(Opcional) Nome abreviado da seguradora. (e.g. Mongeral (mag) e SICOOB (sic))"
    default     = "mag"
}
variable "ambiente" {
    description = "(Required) Tipo de ambiente abreviado. (e.g dev, tst, hmg, stg, prd)"
}
variable "vm_annotation" {
    description = "(Required) Nota com informações para identificação da máquina. (e.g Criado em; Seguradora; Release; Sistema;)"
}
variable "nomemodulo" {
    description = "(Required) Nome do modulo ou sistema (e.g eSim, FerramentasTI, etc)"
}
variable "versao" {
    description = "(Required) Número do pipeline."
}
