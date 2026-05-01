{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  # kmod,
}:

stdenv.mkDerivation rec {
  pname = "acer-wmi-battery";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "frederik-h";
    repo = pname;
    rev = "main";
    # hash = "0";
    hash = "sha256-mI6Ob9BmNfwqT3nndWf3jkz8f7tV10odkTnfApsNo+A=";
  };

  patches = [ ./acer.patch ];

  # sourceRoot = "source/linux/v4l2loopback";
  hardeningDisable = [
    "pic"
    "format"
  ]; # 1
  nativeBuildInputs = kernel.moduleBuildDependencies; # 2

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}" # 3
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # 4
    "INSTALL_MOD_PATH=$(out)" # 5
  ];

  meta = {
    description = "A kernel module to configure acer battery on laptops";
    homepage = "https://github.com/aramg/droidcam";
    license = lib.licenses.gpl2;
    # maintainers = [ lib.maintainers.makefu ];
    platforms = lib.platforms.linux;
  };
}
