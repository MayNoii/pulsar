{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  cmake,
  alsa-lib,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "tap";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "timdubbins";
    repo = "tap";
    rev = "v${version}";
    hash = "sha256-pNKJ2sNZdqNR65h45rqsA358Zb3fRsHe9NumUGqqqvg=";
  };

  cargoHash = "sha256-8tOJXa8bRhqrPSwySxVvL0raf9JyFe8+9R9U31dg54g=";

  nativeBuildInputs = [
    # installShellFiles
    pkg-config
    cmake
    # alsa-lib
  ];

  buildInputs = [
    alsa-lib
    openssl
  ];

  meta = {
    mainProgram = "tap";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
