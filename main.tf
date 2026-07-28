terraform {
  required_version = ">= 1.5.0"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 1.0"
    }
  }

  cloud {
    organization = "test_terraform_wissal"

    workspaces {
      name = "wissal-demo"
    }
  }
}



provider "snowflake" {
  

}

resource "snowflake_database" "demo_db" {
  name    = "DEMO_DB"
  comment = "Database created by Terraform"
}

resource "snowflake_schema" "demo_schema" {
  database = snowflake_database.demo_db.name
  name     = "DEMO_SCHEMA"
  comment  = "Schema created by Terraform"
}

resource "snowflake_table" "weather_json" {
  database = snowflake_database.demo_db.name
  schema   = snowflake_schema.demo_schema.name
  name     = "WEATHER_JSON"

  column {
    name = "VAR"
    type = "VARIANT"
  }
}

resource "snowflake_file_format" "json_format" {
  name     = "JSON_FORMAT"
  database = snowflake_database.demo_db.name
  schema   = snowflake_schema.demo_schema.name

  format_type       = "JSON"
  compression       = "NONE"
  strip_outer_array = true
}

resource "snowflake_view" "weather_view" {
  database = snowflake_database.demo_db.name
  schema   = snowflake_schema.demo_schema.name
  name     = "WEATHER_VIEW"

  statement = <<SQL
SELECT *
FROM WEATHER_JSON;
SQL
}
