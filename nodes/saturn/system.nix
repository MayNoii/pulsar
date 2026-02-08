{
  # config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./acer-wmi-battery
  ];

  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;

  boot = {
    # kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" ];
  };

  networking = {
    hostName = "saturn";

    nftables.enable = true;

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      # dns = "none";
    };
  };

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  console = lib.mkDefault {
    earlySetup = true;
    font = "latarcyrheb-sun16";
    # packages = with pkgs; [ terminus_font ];
    useXkbConfig = true;
    colors = [
      # "1e1e2e" # base
      # "f38ba8" # red
      # "a6e3a1" # green
      # "f9e2af" # yellow
      # "89b4fa" # blue
      # "f5c2e7" # pink
      # "94e2d5" # teal
      # "bac2de" # subtext1

      # "585b70" # surface2
      # "f38ba8" # red
      # "a6e3a1" # green
      # "f9e2af" # yellow
      # "89b4fa" # blue
      # "f5c2e7" # pink
      # "94e2d5" # teal
      # "a6adc8" # subtext0
      "000000" # base
      "ff0030" # red
      "30ff00" # green
      "ffd000" # yellow
      "0030ff" # blue
      "d000ff" # pink
      "00ffd0" # teal
      "ffffff" # subtext1

      "000000" # base
      "ff0030" # red
      "30ff00" # green
      "ffd000" # yellow
      "0030ff" # blue
      "d000ff" # pink
      "00ffd0" # teal
      "ffffff" # subtext1
    ];
  };

  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true;

    nvidia = {
      open = true;

      powerManagement.enable = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # Bus ID of the AMD GPU. You can find it using lspci, either under 3D or VGA
        amdgpuBusId = "PCI:6:0:0";
        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  services = {
    adguardhome = {
      enable = true;
      mutableSettings = true;
      allowDHCP = true;
      host = "127.0.0.1";
      openFirewall = true;

      settings = {
        dns = {
          upstream_dns = [
            "https://dns10.quad9.net/dns-query"
            "https://wikimedia-dns.org/dns-query"
            "https://dns.nextdns.io"
            "https://dns.mullvad.net/dns-query"
            "https://dns.google/dns-query"
            # "https://zero.dns0.eu/"
            "https://dns.us.futuredns.eu.org/dns-query"
            "https://dns.cloudflare.com/dns-query"
            "https://doh.sandbox.opendns.com/dns-query"
            # "https://dns.bebasid.com/unfiltered"
            "https://unfiltered.adguard-dns.com/dns-query"
          ];
        };
      };
    };

    xserver.videoDrivers = [ "nvidia" ];

    dbus.implementation = "broker";

    pulseaudio.enable = false;

    # power-profiles-daemon.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # extraConfig = {
      #   pipewire."92-low-latency" = {
      #     "context.properties" = {
      #       "default.clock.rate" = 48000;
      #       "default.clock.quantum" = 2048;
      #       "default.clock.min-quantum" = 2048;
      #       "default.clock.max-quantum" = 2048;
      #     };
      #   };
      #   pipewire-pulse."92-low-latency" = {
      #     "context.properties" = [
      #       {
      #         name = "libpipewire-module-protocol-pulse";
      #         args = { };
      #       }
      #     ];
      #     "pulse.properties" = {
      #       "pulse.min.req" = "2048/48000";
      #       "pulse.default.req" = "2048/48000";
      #       "pulse.max.req" = "2048/48000";
      #       "pulse.min.quantum" = "2048/48000";
      #       "pulse.max.quantum" = "2048/48000";
      #     };
      #     "stream.properties" = {
      #       "node.latency" = "2048/48000";
      #       "resample.quality" = 1;
      #     };
      #   };
      # };
      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/alsa.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                {
                  # Matches all sources
                  node.name = "~alsa_input.*"
                },
                {
                  # Matches all sinks
                  node.name = "~alsa_output.*"
                }
              ]
              actions = {
                update-props = {
                  session.suspend-timeout-seconds = 0
                }
              }
            }
          ]
        '')
      ];
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    fwupd.enable = true;
  };

  security = {
    pki.certificateFiles = [ ../../../../.local/share/mkcert/rootCA.pem ];

    rtkit = {
      enable = true;
      # args = [
      #   "--no-canary"
      #   "--scheduling-policy=FIFO"
      #   "--our-realtime-priority=89"
      #   "--max-realtime-priority=88"
      #   "--min-nice-level=-19"
      #   "--rttime-usec-max=2000000"
      #   "--users-max=100"
      #   "--processes-per-user-max=1000"
      #   "--threads-per-user-max=10000"
      #   "--actions-burst-sec=10"
      #   "--actions-per-burst-max=1000"
      # ];
    };
  };

  environment.systemPackages = with pkgs; [
    # gnome-boxes
    dualsensectl
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older
  # NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see
  # https://nixos.org/manual/nixos/stable/#sec-upgrading for how to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make
  # to your configuration, and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
