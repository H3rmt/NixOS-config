{ lib, config, ... }: {
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks."10-eth" = {
      matchConfig.Name = "eth0";
      dns = config.nameservers;
      address = [
        "128.140.32.233/32"
        "2a01:4f8:c0c:e6fe::1/64"
      ];
      routes = [
        { routeConfig.Gateway = "fe80::1"; }
        { routeConfig.Gateway = "172.31.1.1"; }
      ];
    };

    networks."20-eth" = {
      matchConfig.Name = "enp7s0";
      address = [
        "10.0.69.1/32"
      ];
    };
  };
}
