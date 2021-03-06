locals {
  api_config_id_prefix     = "api"
  api_gateway_container_id = "return-api-gw"
  gateway_id               = "gw"
}

resource "google_api_gateway_api" "api_gw" {
  provider     = google-beta
  api_id       = local.api_gateway_container_id
  display_name = "The API Gateway"
  project    = "ada-return"

}

resource "google_api_gateway_api_config" "api_cfg" {
  provider      = google-beta
  api           = google_api_gateway_api.api_gw.api_id
  api_config_id_prefix = local.api_config_id_prefix
  display_name  = "The Config"
  project    = "ada-return"

  openapi_documents {
    document {
      path     = "spec.yml"
      contents = filebase64("spec.yml")
    }
  }
}

resource "google_api_gateway_gateway" "gw" {
  provider   = google-beta
  region     = "europe-west1"
  project    = "ada-return"

  api_config   = google_api_gateway_api_config.api_cfg.id

  gateway_id   = local.gateway_id
  display_name = "The Gateway"

  depends_on = [google_api_gateway_api_config.api_cfg]
}
