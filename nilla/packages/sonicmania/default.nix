{
  lib,
  icoutils,
  # stdenv,
  clangStdenv,
  autoPatchelfHook,
  makeDesktopItem,
  writeShellApplication,
  writeText,
  fetchFromGitHub,
  cmake,
  pkg-config,
  glew,
  glfw,
  libtheora,
  zlib,
  SDL2,
  tinyxml2,
  asio,
  xorg,
  libX11,
  libpulseaudio,
  vulkan-loader,
  vulkan-headers,
  vulkan-validation-layers,
  freetype,
  vulkan-tools, # vulkaninfo
  shaderc, # GLSL to SPIRV compiler - glslc
  renderdoc, # Graphics debugger
  tracy, # Graphics profiler
  vulkan-tools-lunarg, # vkconfig
}:

let
  stdenv = clangStdenv;
  # desktopIcon = ''
  #   [Desktop Entry]
  #   Type=Application
  #   Version=1.0
  #   Name=Sonic Mania
  #   Icon=rsdkv5u
  #   Exec=mania
  #   Categories=Game;
  #   Keywords=Sonic;Mania;Mania Plus;
  #   MimeType=x-scheme-handler/smmm
  # '';

  desktopItem = makeDesktopItem {
    name = "SonicMania";
    desktopName = "Sonic Mania";
    icon = "rsdkv5u";
    exec = "mania";
  };

  shaderIni = writeText "shaderIni" ''
    Name=OpenGL Shaders
    Description=Fixes video playback and the shader option in settings
    Author=Ducky
    Version=1.0.0
    TargetVersion=5
  '';

  libPath = lib.makeLibraryPath [
    libpulseaudio
    freetype
    vulkan-loader
    vulkan-validation-layers
  ];

  launcher = writeShellApplication {
    name = "mania";
    text = ''
      export LD_LIBRARY_PATH="/OUTPUT/lib:${libPath}"
      # Use XDG_DATA_HOME or fallback to ~/.local/share if it isn't set.
      data_folder="''${XDG_DATA_HOME:-$HOME/.local/share}/sonicmania"

      if [[ ! -d "$data_folder" ]]; then
      	mkdir -p "$data_folder/mods/Shaders"
      	cp -r /OUTPUT/share/mods/Shaders/Data "$data_folder/mods/Shaders"
      	cp ${shaderIni} "$data_folder/mods/Shaders/mod.ini"
      	echo "Created data folder in '$data_folder', please copy Data.rsdk" \
        "from an existing Mania(+) install there and run this launcher again."
      exit 1
      fi

      cd "$data_folder"
      /OUTPUT/lib/RSDKv5U

      exit_code=$?

      if [[ $exit_code -eq 1 ]]; then
      	echo "Game exited with error code 1, check if data files are present in" \
      "'$data_folder'."
      fi
    '';
  };

in
stdenv.mkDerivation {
  pname = "SonicManiaDecompilation";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "RSDKModding";
    repo = "Sonic-Mania-Decompilation";
    rev = "8795c5af1ec925152b383bd8ddb68e49a52b15ae";
    hash = "sha256-9+tRiY0lPC3sfdEtEOEI13V1UmyMbjaWj0TpnDeK2vU=";
    fetchSubmodules = true;
  };

  buildInputs = [
    glew
    glfw
    libtheora
    zlib
    SDL2
    tinyxml2
    asio
    xorg.libXext
    xorg.libXrandr
    libX11
    xorg.libXfixes
    xorg.libXi
    xorg.libXScrnSaver
    xorg.libXcursor
    vulkan-loader
    vulkan-headers
    vulkan-validation-layers
    freetype
    vulkan-tools # vulkaninfo
    shaderc # GLSL to SPIRV compiler - glslc
    renderdoc # Graphics debugger
    tracy # Graphics profiler
    vulkan-tools-lunarg # vkconfig
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    autoPatchelfHook
  ];

  cmakeFlags = [
    "-Bbuild"
    "-DRETRO_SUBSYSTEM=VK"
    # "-DCMAKE_CXX_FLAGS=-U_FORTIFY_SOURCE"
    # "-DCMAKE_CXX_FLAGS='-D_FORTIFY_SOURCE=0'"
  ];

  hardeningDisable = [ "fortify" ];

  buildPhase = ''
    cmake --build build --config release
  '';

  installPhase = ''
    # ls --recursive /build
    install -D /build/source/build/build/dependencies/RSDKv5/RSDKv5U -t $out/lib
    install -D /build/source/build/build/dependencies/RSDKv5/libGame.so $out/lib/Game.so
    mkdir $out/share/mods/Shaders/Data -p
    cp /build/source/dependencies/RSDKv5/RSDKv5/Shaders $out/share/mods/Shaders/Data -r 
    # Install the icon
    pushd /build/source/dependencies/RSDKv5/RSDKv5U/
    ${icoutils}/bin/icotool -x ./RSDKv5U.ico
    install -D ./RSDKv5U_7_1024x1024x32.png $out/share/icons/hicolor/1024x1024/apps/rsdkv5u.png
    popd
    # Install the desktop item
    install -D ${desktopItem}/share/applications/SonicMania.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/SonicMania.desktop \
      --replace "Icon=rsdkv5u" "Icon=$out/share/icons/hicolor/1024x1024/apps/rsdkv5u.png"
    # Install the launcher
    install -D ${launcher}/bin/mania -t $out/bin
    substituteInPlace $out/bin/mania \
      --replace /OUTPUT $out
  '';

  meta = with lib; {
    description = "A complete decompilation of Sonic Mania (2017)";
    homepage = "https://github.com/Rubberduckycooly/Sonic-Mania-Decompilation";
    platforms = [ "x86_64-linux" ];
    # license = licenses.custom;
    # maintainers = with maintainers; [  ];
  };
}
