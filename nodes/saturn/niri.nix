{
  # config,
  # lib,
  pkgs,
  # project,
  inputs,
  nillapkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  # qs-package = pkgs.callPackage "${inputs.quickshell}/default.nix" {};
in
{
  services = {
    displayManager.ly = {
      enable = true;
      x11Support = false;
      settings = {
        animation = "colormix";
        hide_version_string = true;
        hide_key_hints = true;
        # gameoflife_fg = "0x0006";
        colormix_col1 = "0x0006";
        colormix_col2 = "0x0004";
        colormix_col3 = "0x0001";
      };
    };

    gnome = {
      games.enable = true;
      # sushi.enable = true;
    };

    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };

  programs = {
    niri = {
      enable = true;
      useNautilus = true;
      package = inputs.niri-flake.packages.${system}.niri-unstable;
      # package = pkgs.niri.overrideAttrs (
      #   finalAttrs: previousAttrs: rec {
      #     name = "niri-${version}";
      #     version = previousAttrs.version;
      #     src = pkgs.fetchFromGitHub {
      #       owner = "niri-wm";
      #       repo = "niri";
      #       rev = "0ca60209c54997624f1e1249f78e0437d8da1969";
      #       hash = "sha256-R3GQb8mJWZCMv2x3LKExgpjM7Kilu8dBxuUGJJjHNEM=";
      #     };
      #     postPatch = ''
      #       patchShebangs resources/niri-session
      #       substituteInPlace resources/niri.service \
      #         --replace-fail 'niri' "$out/bin/niri"
      #     '';
      #     cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      #       inherit name src;
      #       hash = "sha256-soJYT6TavlyqtVqMD70QYDZ+8swn6TVXsFHadJxaxWo=";
      #     };
      #   }
      # );
    };

    seahorse.enable = true;

    dms-shell = {
      # enable = true;
      # quickshell.package = qs-package;
      enableDynamicTheming = false;
      enableCalendarEvents = false;
      enableVPN = false;
    };
  };

  qt = {
    enable = true;
    # platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.systemPackages =
    (with pkgs; [
      adw-gtk3
      nautilus
      adwaita-icon-theme
      adwaita-icon-theme-legacy

      decibels
      loupe
      papers
      # gnome-secrets
      gradia
      planify

      swayidle
      brightnessctl
      hyprlock

      vicinae
      # fuzzel
      awww
      dunst
      # mako
      # fnott
      # clipse
      pavucontrol
      networkmanagerapplet
      bluetui

      xwayland-satellite

      (writers.writeBashBin "gnome-polkit" { } ''
        ${mate-polkit}/libexec/polkit-mate-authentication-agent-1
      '')
      # soteria
    ])
    ++ [
      (inputs.ignis.packages.${system}.ignis.override {
        enableAudioService = true;
        enableBluetoothService = true;
        useGrassSass = true;
        extraPackages = with pkgs; [
          libevdev
          python313Packages.libevdev
          python313Packages.open-meteo
        ];
      })
      nillapkgs.goignis.${system}
    ];

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "com.mitchellh.ghostty"
      ];
    };
  };

  security = {
    pam.services.hyprlock = { };
    # soteria.enable = true;
  };
}
