{
  lua54Packages,
  fetchFromGitHub,
}:
let
  lua = lua54Packages.lua;
in
lua.pkgs.buildLuarocksPackage {
  pname = "lnko";
  version = "scm-1";

  src = fetchFromGitHub {
    owner = "luanvil";
    repo = "lnko";
    rev = "7a7890d6ef37dba1b2f7cfea5ba028e73339cd49";
    hash = "sha256-8kskzxgdSunrcaDIzUjGQgDZ5sz9Onr46nTNZNv+neg=";
  };

  disabled = lua.pkgs.luaOlder "5.1" || lua.pkgs.luaAtLeast "5.5";
  propagatedBuildInputs = [ lua.pkgs.luafilesystem ];

  meta = {
    homepage = "https://github.com/luanvil/lnko";
    license.fullName = "GPL-3.0";
    description = "Simple stow-like dotfile linker";
  };
}
