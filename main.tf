/**
 * [![Build Status](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/buildStatus/icon?job=dcos-terraform%2Fterraform-azurerm-tested-oses%2Fsupport%252F0.1.x)](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/job/dcos-terraform/job/terraform-azurerm-tested-oses/job/support%252F0.1.x/)
 *
 * Azure DC/OS Tested OSes
 * ==========
 * This module returns for an given OS the Azure Image as well as its default user and the prerequisits script
 *
 * EXAMPLE
 * -------
 *
 * ```hcl
 * module "dcos-tested-oses" {
 *   source  = "terraform-dcos/tested-oses/azurerm"
 *   version = "~> 0.1.0"
 *
 *   os = "centos_7.3"
 * }
 * ```
 */

locals {
  os_name    = "${element(split("_", var.os),0)}"
  os_version = "${element(split("_", var.os),1)}"

  os_special_version_script = {
    centos = ["7.3", "7.5", "7.6"]
    coreos = []
    rhel   = []
  }

  user            = "${lookup(var.traditional_default_os_user, local.os_name)}"
  azure_offer     = "${element(var.azure_os_image_version[var.os], 0)}"
  azure_publisher = "${element(var.azure_os_image_version[var.os], 1)}"
  azure_sku       = "${element(var.azure_os_image_version[var.os], 2)}"
  azure_version   = "${element(var.azure_os_image_version[var.os], 3)}"
  script          = "${file("${path.module}/scripts/${local.os_name}/${contains(local.os_special_version_script[local.os_name], local.os_version) ? local.os_version : "setup"}.sh")}"
}
