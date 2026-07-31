#!/usr/bin/env -S just --justfile

help:
    #!/usr/bin/env bash
    CYAN="36"
    STYLE="\e[1;${CYAN}m"
    BOLD="\e[1m"
    RESET="\e[0m"

    echo -e "---- ${STYLE}nia${RESET} ----
    A collection of helpful NixOS scripts

    ${BOLD}Commands:${RESET}"

    just --list --unsorted --list-heading ''
    echo

alias s := sync
alias top := topgrade

export MANPAGER := "less -R --use-color -Dd+m -Du+b"
export MANROFFOPT := "-P -c"

[group("system")]
switch *A:
    nh os switch {{ A }} -f saturn.nix -e run0 -a

[group("system")]
boot *A:
    nh os boot {{ A }} -f saturn.nix -e run0 -a

[group("system")]
test *A:
    nh os test {{ A }} -f saturn.nix -e run0 -a

[group("system")]
build *A:
    nh os build {{ A }} -f saturn.nix -e run0 -a

[group("system")]
repl *A:
    nh os repl {{ A }} -f saturn.nix -e run0

[group("helper")]
sync:
    npins update

[group("helper")]
topgrade:
    topgrade --disable=nix --disable=system --disable=git_repos --disable=helix

[group("helper")]
pins +ARGS:
    npins {{ ARGS }}

[group("helper")]
out +ARGS:
    nilla {{ ARGS }}

[group("info")]
diff n="1":
    #!/usr/bin/env nu
    ls /nix/var/nix/profiles/system-*
        | get name
        | sort -nr
        | dix ($in | get {{ n }}) ($in | first)

[group("info")]
np:
    #!/bin/sh
    cat ./npins/sources.json

[group("info")]
tree:
    nix-tree
