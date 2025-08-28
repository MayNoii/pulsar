{
  # config,
  # lib,
  pkgs,
  # project,
  inputs,
  nillapkgs,
  ...
}:
{
  services = {
    displayManager.ly = {
      enable = true;
      x11Support = false;
      settings = {
        animation = "colormix";
        hide_version_string = true;
        hide_key_hints = true;
        # colormix_col1 = "0x00FF0030";
        # colormix_col2 = "0x000030FF";
      };
    };

    gnome = {
      games.enable = true;
    };

    gvfs.enable = true;
  };

  programs = {
    niri.enable = true;
  };

  environment.systemPackages =
    (with pkgs; [
      adw-gtk3
      nautilus
      adwaita-icon-theme
      adwaita-icon-theme-legacy
      gradia

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
      (inputs.ignis.packages.${pkgs.system}.ignis.override {
        enableAudioService = true;
        enableBluetoothService = true;
        useGrassSass = true;
        extraPackages = with pkgs; [
          libevdev
          python313Packages.libevdev
        ];
      })
      nillapkgs.goignis.${pkgs.system}
    ];

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "com.mitchellh.ghostty"
      ];
    };
  };
}
