# module "dns-private-zone" {
#   source  = "terraform-google-modules/cloud-dns/google"
#   project_id = var.project_id
#   type       = "private"
#   name       = "asaf-veeva-com"
#   domain     = "asaf-veeva.com."

# #   private_visibility_config_networks = [
# #     "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/${google_compute_network.vpc.id}"
# #   ]

#   recordsets = [
#     {
#       name    = "localhost"
#       type    = "A"
#       ttl     = 300
#       records = [
#         "127.0.0.1",
#       ]
#     },
#   ]
# }