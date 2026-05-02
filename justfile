#!/usr/bin/env -S just --justfile

help:
    #!/usr/bin/env bash
    CYAN="36"
    STYLE="\e[1;${CYAN}m"
    BOLD="\e[1m"
    RESET="\e[0m"

    echo -e "--- ${STYLE}nia${RESET} ---
    A collection of helpful NixOS scripts

    ${BOLD}Commands:${RESET}"

    just --list --unsorted --list-heading ''
    echo

# alias b := build
# alias a := apply
# alias d := deploy

alias b := build
alias rb := rebuild
alias up := upgrade
alias s := sync
alias top := topgrade

# [group("colmena")]
# build:
#     colmena build --evaluator streaming
# [group("colmena")]
# apply TYPE:
#     colmena apply --evaluator streaming {{ TYPE }}

[group("colmena")]
rebuild +A:
    run0 colmena apply-local {{ A }}
[group("colmena")]
switch: (rebuild "switch")
[group("colmena")]
upgrade: (rebuild "boot")

[group("colmena")]
build:
    nix build --expr '(import ./saturn.nix).toplevel' --no-link --impure

# [group("system")]
# rebuild +A:
#     run0 nixos-rebuild {{ A }} -f saturn.nix --no-flake

[group("helper")]
sync:
    npins update

[group("helper")]
topgrade:
    topgrade --disable=nix --disable=system

[group("helper")]
pins +ARGS:
    npins {{ ARGS }}

[group("helper")]
col +ARGS:
    colmena {{ ARGS }}

[group("helper")]
out +ARGS:
    nilla {{ ARGS }}

[group("helper")]
repl:
    colmena repl

[group("helper")]
np:
    cat ./npins/sources.json
