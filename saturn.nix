let
  project = import ./nilla.nix;
  nixpkgs = project.inputs.nixpkgs.result.x86_64-linux;
  saturn = import (nixpkgs.path + "/nixos/lib/eval-config.nix") {
    system = null;
    specialArgs = {
      inherit project;
      inputs = builtins.mapAttrs (_: input: input.result) project.inputs;
      nillapkgs = builtins.mapAttrs (_: package: package.result) project.packages;
    };
    modules = [
      {
        networking.hostName = "saturn";

        imports = [
          ./nodes/saturn
          ./modules
        ];

        nixpkgs.pkgs = nixpkgs;
        nixpkgs.localSystem = nixpkgs.stdenv.hostPlatform;
      }
    ];
  };
in
saturn.config.system.build // saturn
