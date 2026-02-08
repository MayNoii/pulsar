{
  # config,
  lib,
  pkgs,
  project,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  nilla-cli-package = inputs.nilla-cli.packages.nilla-cli.result.${system};
in
{
  imports = [
    # (import "${inputs.lix-module}/module.nix" { lix = null; })
    ./niri.nix
    # ./gnome.nix
  ];

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "lix-custom-sub-commands"
      ];
      # Cachix configurations
      # builders-use-substitutes = true;
      extra-substituters = [
        # "https://hyprland.cachix.org"
        # "https://nixpkgs-wayland.cachix.org"
        # "https://helix.cachix.org"
        # "https://anyrun.cachix.org"
        # "https://viperml.cachix.org"
        # "https://nix-gaming.cachix.org"
        "https://cache.lix.systems"
      ];
      trusted-public-keys = [
        # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        # "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        # "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        # "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
        # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      # plugin-files = "${
      #   pkgs.nix-plugin-pijul.override { nix = config.nix.package; }
      # }/lib/nix/plugins/pijul.so";
    };
    # nixPath = lib.mkForce [ "nixpkgs=flake:nixpkgs" ];
    # channel.enable = false;
  };
  nixpkgs.flake.source = lib.mkForce project.inputs.nixpkgs.src;

  users.users.moon = {
    isNormalUser = true;
    uid = 1000;
    description = "Munds";
    extraGroups = [
      "networkmanager"
      "wheel"
      "keyd"
      "transmission"
      "qbittorrent"
      "pipewire"
      "input"
    ];
    shell = pkgs.bash;
    packages = with pkgs; [
      hello
    ];
  };
  # documentation.man.generateCaches = false; # Disable the fish generation

  fonts = {
    fontconfig = {
      hinting.enable = false;
      subpixel.lcdfilter = "none";
    };
    packages = with pkgs; [
      atkinson-hyperlegible-next
      atkinson-hyperlegible-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      maple-mono.truetype
      nerd-fonts.space-mono
      font-awesome
      adwaita-fonts
    ];
  };

  services = {
    flatpak.enable = true;

    whoogle-search = {
      enable = true;
      extraEnv = {
        WHOOGLE_CONFIG_LANGUAGE = "lang_en";
        WHOOGLE_CONFIG_SEARCH_LANGUAGE = "lang_en";
      };
    };
  };

  programs = {
    command-not-found.enable = false;
    nix-index-small = {
      enable = true;
      extraBins = true;
    };
  };

  virtualisation.podman.enable = true;

  environment = {
    # etc."containers/systemd/whoogle.container".source = ./system-containers/whoogle.container;
    # etc."containers/systemd/pihole.container".source = ./system-containers/pihole.container;

    etc."security/limits.d/95-pipewire.conf".text = ''
      # Default limits for users of pipewire
      @pipewire - rtprio 95
      @pipewire - nice -19
      @pipewire - memlock 4194304
    '';

    sessionVariables = {
      # NAUTILUS_4_EXTENSION_DIR = lib.mkForce "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    };
    variables = {
      EDITOR = "hx";
      NIXOS_OZONE_WL = "1";
      # PIX_DEFSHELL = "fish";
      # man colors
      # GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
      # FIXME: This is due to an upstream bug with Nvidia drivers.
      # GSK_RENDERER = "ngl";
      COMMA_PICKER = "fzf";
    };
    # pathsToLink = [ "/share/nautilus-python/extensions" ];

    systemPackages = with pkgs; [
      (writeShellApplication {
        name = "nia";

        runtimeInputs = [
          just
          bash
          nushell
          lixPackageSets.latest.colmena
          nvd
          npins
          nilla-cli-package
        ];

        text = ''
          just --justfile /home/moon/Documents/pulsar/justfile "$@"
        '';
      })
      nilla-cli-package
      npins
      lixPackageSets.latest.colmena

      nvd
      nix-output-monitor
      nix-tree
      # nix-melt
      # nix-inspect
      nix-du
      nix-btm
      lixPackageSets.latest.nix-eval-jobs
      # nix-eval-jobs
      just

      wget
      prettyping
      pv
      zip
      unzip
      chafa
    ];
  };

  # Set sudo-rs as our default sudo provider
  security = {
    # soteria.enable = true;
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };
}
