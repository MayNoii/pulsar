{ config, ... }:
let
  pins = import ../npins;

  nixpkgs-flake = config.inputs.flake-compat.result.load {
    inherit (config.inputs.nixpkgs) src;
  };

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  loaders = {
    nixpkgs = "nixpkgs";
    nixpkgs-stable = "nixpkgs";
    nilla-cli = "nilla";
    nilla = "nilla";
    nix-index-database = "legacy";
    lix-module = "raw";
    ignis = "flake";
    flake-compat = "legacy";
  };

  settings = {
    nixpkgs = {
      inherit systems;
      configuration = {
        allowUnfree = true;
        # allowBroken = true;
      };
    };

    ignis = {
      inputs = {
        nixpkgs = nixpkgs-flake;
      };
    };

    nixpkgs-stable = settings.nixpkgs;
  };
in
{
  config = {
    inputs = builtins.mapAttrs (name: pin: {
      src = pin;

      loader = loaders.${name} or { };
      settings = settings.${name} or { };
    }) pins;

    modules.pulsar = {
      defaultSystems = systems;
    };

    shells.default = {
      inherit systems;

      shell =
        { pkgs, ... }:
        pkgs.mkShell {
          packages = with pkgs; [
            sl

            nixd
            nixfmt
            statix
          ];
        };
    };

    packages = {
      fmt = {
        inherit systems;

        package =
          { nixfmt-tree, writeScriptBin, ... }:
          writeScriptBin "format" ''
            ${nixfmt-tree}/bin/treefmt ~/Documents/pulsar
          '';
      };

      apotris = {
        inherit systems;
        package = import ./packages/apotris;
      };

      sonicmania = {
        inherit systems;
        package = import ./packages/sonicmania;
      };

      goignis = {
        inherit systems;
        package = import ./packages/goignis;
      };
    };
  };
}
