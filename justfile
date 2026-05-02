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
# alias man := manual
# alias ls := list
# alias in := inputs

# export MANPAGER := "less -R --use-color -Dd+m -Du+b"
# export MANROFFOPT := "-P -c"

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

# dunstify "Rebuild ongoing" "Please remember to input your password" -a "nia"

# [group("system")]
# rebuild +A:
#     run0 nixos-rebuild {{ A }} -f saturn.nix --no-flake

# [group("system")]
# pretty: build (rebuild "switch") diff

# [group("system")]
# upgrade: build (rebuild "boot") topgrade diff

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

# [group("helper")]
# which BIN:
#     readlink -f $(which {{ BIN }})

# [group("helper")]
# closure BIN:
#     nix-tree $(readlink -f $(which {{ BIN }}))

# [group('info')]
# manual:
#     man configuration.nix

[group("helper")]
repl:
    colmena repl

# [group('info')]
# list *F:
#     nvd list -r /nix/var/nix/profiles/system {{ F }}

# [group("info")]
# diff n="1":
#     #!/usr/bin/env nu
#     ls /nix/var/nix/profiles/system-*
#         | get name
#         | sort -nr
#         | nvd diff ($in | get {{ n }}) ($in | first)

# [group("info")]
# inputs:
#     #!/usr/bin/env nu
#     open ./npins/sources.json | get pins | transpose name info | get name

# [group("info")]
# deps:
#     #!/usr/bin/env nu
#     open ./npins/sources.json | get pins | table -e

# [group("info")]
# tree:
#     nix-tree

[group("helper")]
np:
    cat ./npins/sources.json
