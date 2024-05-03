let
  main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGf/xbMe34ZiUGqm6y9RWQkRkKcU9aKd/wTQdcRUAC3I";
in
{
  "authentik/pg_pass.age".publicKeys = [ main ];
  "authentik/authentik_key.age".publicKeys = [ main ];
  "grafana/client_secret.age".publicKeys = [ main ];
  "grafana/client_key.age".publicKeys = [ main ];
}
