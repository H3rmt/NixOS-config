let
  main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIChc0OADBHo5eqE4tcVHglCGzUvHSTZ6LeC0RcGQ9V6C";
  my = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAA/Iusb9djUIvujvzUhkjW7cKysbuNwJPNd/zjmZc+t";
in
{
  "borg_pass.age".publicKeys = [ main my ];
  "root_pass.age".publicKeys = [ main my ];
  "wireguard_private.age".publicKeys = [ main my ];
}
