{ lib, config, pkgs, ... }:
let
  clib = import ../../shared/funcs.nix { inherit lib; inherit config; };
in
{
  imports = [
    ../../shared/users.nix
  ];

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;
  users.users = {
    reverseproxy = {
      createHome = true;
      isNormalUser = true;
      shell = pkgs.zsh;
      linger = true;
    };
    authentik = {
      createHome = true;
      isNormalUser = true;
      shell = pkgs.zsh;
      linger = true;
    };
    grafana = {
      createHome = true;
      isNormalUser = true;
      shell = pkgs.zsh;
      linger = true;
    };
    tor = {
      createHome = true;
      isNormalUser = true;
      shell = pkgs.zsh;
      linger = true;
    };
    wakapi = {
      createHome = true;
      isNormalUser = true;
      shell = pkgs.zsh;
      linger = true;
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.reverseproxy = import ./reverseproxy.nix { age = config.age; inherit clib; };
  home-manager.users.authentik = import ./authentik.nix { age = config.age; inherit clib; };
  home-manager.users.grafana = import ./grafana.nix { age = config.age; inherit clib; };
  home-manager.users.tor = import ./tor.nix { age = config.age; inherit clib; };
  home-manager.users.wakapi = import ./wakapi.nix { age = config.age; inherit clib; };
}
