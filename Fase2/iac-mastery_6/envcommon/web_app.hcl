# envcommon/web_app.hcl
terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/modules/infra"
}
