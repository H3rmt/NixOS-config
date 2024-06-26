{ lib, config, ... }: {
  systemd.network = {
    enable = true;
    networks."10-eth" = {
      matchConfig.Name = "eth0";
      dns = config.nameservers ++ config.nameservers-hetzner;
      address = [
        "159.69.206.86/32"
        "2a01:4f8:1c1b:59c0::1/64"
      ];
      routes = [
        { Gateway = "fe80::1"; GatewayOnLink = true; }
        { Gateway = "172.31.1.1"; GatewayOnLink = true; }
      ];
      linkConfig.RequiredForOnline = "yes";
    };
    networks."30-wg" = {
      matchConfig.Name = "wg0";
      address = [
        "${config.server.main-2.private-ip}/24"
      ];
      linkConfig.RequiredForOnline = "no";
    };

    netdevs."30-wg" = {
      netdevConfig = {
        Name = "wg0";
        Kind = "wireguard";
      };
      wireguardConfig = {
        PrivateKeyFile = config.age.secrets.wireguard_private.path;
        ListenPort = config.ports.exposed.wireguard;
      };
      wireguardPeers = [
        {
          PublicKey = "${config.server.raspi-1.public-key-wg}";
          AllowedIPs = "${config.server.raspi-1.private-ip}/32";
        }
        {
          PublicKey = "${config.server.main-1.public-key-wg}";
          AllowedIPs = "${config.server.main-1.private-ip}/32";
          Endpoint = "128.140.32.233:${toString config.ports.exposed.wireguard}";
          PersistentKeepalive = 25;
        }
      ];
    };

    links."10-eth" = {
      matchConfig.PermanentMACAddress = "96:00:03:4d:13:4f";
      linkConfig.Name = "eth0";
    };
  };
}
