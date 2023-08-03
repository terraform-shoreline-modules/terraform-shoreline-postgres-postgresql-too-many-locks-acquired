resource "shoreline_notebook" "postgresql_too_many_locks_acquired" {
  name       = "postgresql_too_many_locks_acquired"
  data       = file("${path.module}/data/postgresql_too_many_locks_acquired.json")
  depends_on = [shoreline_action.invoke_diagnose_locks_script]
}

resource "shoreline_file" "diagnose_locks_script" {
  name             = "diagnose_locks_script"
  input_file       = "${path.module}/data/diagnose_locks_script.sh"
  md5              = filemd5("${path.module}/data/diagnose_locks_script.sh")
  description      = "A database query is acquiring a large number of locks, causing the lock limit to be exceeded."
  destination_path = "/agent/scripts/diagnose_locks_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_diagnose_locks_script" {
  name        = "invoke_diagnose_locks_script"
  description = "A database query is acquiring a large number of locks, causing the lock limit to be exceeded."
  command     = "`chmod +x /agent/scripts/diagnose_locks_script.sh && /agent/scripts/diagnose_locks_script.sh`"
  params      = ["DATABASE_USER","DATABASE_PASSWORD","DATABASE_NAME","DATABASE_HOST"]
  file_deps   = ["diagnose_locks_script"]
  enabled     = true
  depends_on  = [shoreline_file.diagnose_locks_script]
}

