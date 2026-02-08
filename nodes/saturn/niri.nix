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
      sushi.enable = true;
    };

    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };

  programs = {
    niri.enable = true;

    evince.enable = true;
    seahorse.enable = true;
  };

  environment.systemPackages =
    (with pkgs; [
      adw-gtk3
      nautilus
      adwaita-icon-theme
      adwaita-icon-theme-legacy

      decibels
      loupe
      gradia
      planify

      kdePackages.qtdeclarative
      quickshell

      swayidle
      brightnessctl
      hyprlock

      fuzzel
      swww
      mako
      clipse
      # playerctl
      pavucontrol
      networkmanagerapplet
      bluetui

      xwayland-satellite

      (writers.writeBashBin "gnome-polkit" { } ''
        ${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      '')
      polkit_gnome
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

  security.pam.services.hyprlock = { };
}
