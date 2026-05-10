{ config, ... }:
let
  kernelPkg = config.boot.kernelPackages.callPackage;
  acer-wmi-battery = kernelPkg ./package.nix { };
in
{
  boot = {
    extraModulePackages = [ acer-wmi-battery ];
    kernelModules = [ "acer-wmi-battery" ];
    extraModprobeConfig = ''
      options acer-wmi-battery enable_health_mode=1
    '';
  };
}
