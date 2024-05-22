{ age, clib, mconfig }: { lib, config, home, pkgs, inputs, ... }:
let
  data-prefix = "${config.home.homeDirectory}/${mconfig.data-dir}";
  
  PODNAME = "tor_pod";
  TOR_VERSION = "v0.2.4";

  exporter = clib.create-podman-exporter "tor" "${PODNAME}";
in
{
  imports = [
    ../../shared/usr.nix
  ];
  home.stateVersion = mconfig.nixVersion;
  home.sessionVariables.XDG_RUNTIME_DIR = "/run/user/$UID";

  home.activation.script = clib.create-folders lib [
    "${data-prefix}/middle/"
  ];

  home.file = clib.create-files config.home.homeDirectory {
    "up.sh" = {
      executable = true;
      text = ''
        podman pod create --name=${PODNAME} \
            -p ${toString mconfig.ports.exposed.tor-middle}:9000 \
            -p ${mconfig.main-nix-2-private-ip}:${exporter.port} \
            --network pasta:-a,172.16.0.1

        podman run --name=middle -d --pod=${PODNAME} \
            -e mode="middle" \
            -e Nickname="Middle" \
            -e ContactInfo="stemmer.enrico@gmail.com" \
            -e ORPort=9000 \
            -e AccountingStart="week 1 00:00" \
            -e AccountingMax="4 TBytes" \
            -e RelayBandwidthRate="1 MBytes" \
            -e RelayBandwidthBurst="2 MBytes" \
            -e MetricsPort=9035 \
            -e MetricsPortPolicy="accept 127.0.0.1" \
            -v ${data-prefix}/middle:/var/lib/tor \
            -u 0:0 \
            --restart unless-stopped \
            docker.io/h3rmt/alpine-tor:${NODE_EXPORTER_VERSION}

        ${exporter.run}
      '';
    };

    "down.sh" = {
      executable = true;
      text = ''
        podman stop -t 10 middle
        podman rm middle
        ${exporter.stop}
        podman pod rm ${PODNAME}
      '';
    };
  };
}