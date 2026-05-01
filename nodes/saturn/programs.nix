{
  # config,
  # lib,
  pkgs,
  # system,
  # project,
  inputs,
  # nillapkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  programs = {
    fish.enable = true;

    zoxide.enable = true;
    # starship = {
    #   enable = true;
    #   transientPrompt = {
    #     enable = true;
    #     left = "starship module character";
    #   };
    # };

    git.enable = true;
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
        package = pkgs.lixPackageSets.latest.nix-direnv;
      };
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamemode.enable = true;

    # firefox.enable = true;
  };

  services = {
    usermpd = {
      enable = true;
      dataDir = "/home/moon/.local/share/mpd";
      musicDirectory = "/home/moon/Music/";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "SaturnPipewire"
        }
      '';
      mpd-mpris = true;
    };

    # transmission = {
    #   enable = true;
    #   package = pkgs.transmission_4;
    #   openPeerPorts = true;
    #   webHome = pkgs.flood-for-transmission;
    # };
    qbittorrent = {
      enable = true;
      serverConfig = {
        LegalNotice.Accepted = true;
        Preferences.WebUI = {
          AlternativeUIEnabled = true;
          RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
          LocalHostAuth = false;
        };
      };
      openFirewall = true;
      webuiPort = 8080;
      torrentingPort = 14104;
    };
  };

  imports = [
    # ./neovim.nix
    ./media.nix
    # ./glance.nix
  ];

  environment.systemPackages =
    (with pkgs; [
      # isd
      vim
      # emacs
      helix
      ruff
      # nixd
      # nixfmt
      # statix
      lazygit
      jujutsu
      ghostty

      # markdown-oxide
      marksman
      dprint
      libreoffice
      # obsidian
      vlc
      # (writeShellScriptBin "vlc" ''
      #   QT_QPA_PLATFORMTHEME=qt5ct ${lib.getExe vlc}
      # '')

      wl-clipboard-rs
      bat
      gh
      glab
      fzf
      fd
      ripgrep
      eza
      tealdeer
      btop
      nitch
      macchina
      starship

      zk
      # bagels

      cmatrix
      cbonsai
      pipes-rs
      astroterm
      fortune
      cowsay
      blahaj
      gay

      libqalculate

      mpc
      rmpc
      cava

      # calcurse
      carl
      dijo
      dooit
      dysk
      fend
      # gitu
      gtrash
      havn
      heh
      hoard
      # khal
      # kalker
      koji
      mdp
      # mprocs
      numbat
      ouch
      # papis
      pastel
      vivid
      dua
      wormhole-rs
      # procs
      # pwdsafety
      qrtool
      # sampler
      serie
      typioca
      wiremix
      yazi
      exiftool

      vivaldi
      vesktop
      # equibop
      # krita
      ungoogled-chromium

      steam-run

      # sm64coopdx
      ringracers
      lumafly
      archipelago
      # nova.apotris

      (writers.writeHaskellBin "missiles" { libraries = [ haskellPackages.acme-missiles ]; } ''
        import Acme.Missiles
        main = launchMissiles
      '')
    ])
    ++ [
      inputs.nixpkgs-stable.${system}.sage
      # nillapkgs.sonicmania.${system}

      # (pkgs.writeShellScriptBin "nomos-rebuild" ''
      #   ${
      #     pkgs.nixos-rebuild-ng.override {
      #       nix = pkgs.symlinkJoin {
      #         name = "nix-or-nom";
      #         paths = [
      #           (pkgs.writeShellScriptBin "nix-build" ''
      #             ${pkgs.nix-output-monitor}/bin/nom-build $@
      #           '')
      #           config.nix.package
      #         ];
      #       };
      #     }
      #   }/bin/nixos-rebuild-ng "$@"
      # '')

      (pkgs.vscodium.fhsWithPackages (
        pkgs: with pkgs; [
          nixfmt
          statix
          nixd

          glib
          zlib
          libGL
          fontconfig
          libX11
          libxkbcommon
          freetype
          dbus
          # texliveMedium
        ]
      ))

      (
        let
          base = pkgs.appimageTools.defaultFhsEnvArgs;
        in
        pkgs.buildFHSEnv (
          base
          // {
            name = "defhs";
            targetPkgs =
              pkgs:
              (base.targetPkgs pkgs)
              ++ (with pkgs; [
                pkg-config
                udev
                cmake
                libtool
                ncurses
                pkg-config
                zlib
                gcc
                gnumake
                curl
                openssl

                python3
                # (poetry.withPlugins (
                #   ps: with ps; [
                #     poetry-plugin-shell
                #   ]
                # ))
                uv
              ]);
            profile = "export FHS=1";
            runScript = "nu";
            extraOutputsToInstall = [ "dev" ];
          }
        )
      )
    ];
}
