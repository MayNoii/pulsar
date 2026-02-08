{ lib, pkgs, ... }:
{
  services = {
    sonarr = {
      # enable = true;
      group = "qbittorrent";
      user = "servarr";
    };

    radarr = {
      # enable = true;
      group = "qbittorrent";
      user = "servarr";
    };

    prowlarr = {
      # enable = true;
      # group = "qbittorrent";
      # user = "servarr";
    };

    jellyfin = {
      enable = true;
      # user = "moon";
    };
  };

  # Configure CPU usage limits on these bad boys
  systemd.services = {
    sonarr.serviceConfig = {
      CPUWeight = 10;
      CPUQuota = "10%";
      # IOWeight = 1;
    };
    radarr.serviceConfig = {
      CPUWeight = 10;
      CPUQuota = "10%";
      # IOWeight = 1;
    };
    # sonarr.wantedBy = lib.mkForce [ ];
    # radarr.wantedBy = lib.mkForce [ ];
    prowlarr = {
      # wantedBy = lib.mkForce [ ];
      serviceConfig = {
        # Also run prowlarr as the servarr user
        DynamicUser = lib.mkForce false;
        User = "servarr";
        CPUWeight = 10;
        CPUQuota = "10%";
        # IOWeight = 1;
      };
    };
  };

  users.users = {
    servarr = {
      isSystemUser = true;
      group = "qbittorrent";
    };
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg

    jellyfin-desktop

    # recyclarr
  ];
}
