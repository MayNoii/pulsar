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
alias os := rebuild
alias up := upgrade
alias s := sync
alias man := manual
alias ls := list
alias in := inputs

export MANPAGER := "less -R --use-color -Dd+m -Du+b"
export MANROFFOPT := "-P -c"

# [group("colmena")]
# build:
#     colmena build --evaluator streaming
# [group("colmena")]
# apply TYPE:
#     colmena apply --evaluator streaming {{ TYPE }}
# [group("colmena")]
# deploy TYPE:
#     colmena apply-local --sudo {{ TYPE }}
# [group("colmena")]
# switch: (deploy "switch") diff
# [group("colmena")]
# all: build (apply "boot") (deploy "boot") diff

[group("system")]
build:
    nom build -E '(import ./saturn.nix).toplevel' --no-link --impure
# dunstify "Rebuild ongoing" "Please remember to input your password" -a "nia"

[group("system")]
rebuild +A:
    run0 nixos-rebuild {{ A }} -f saturn.nix --no-flake

[group("system")]
pretty: build (rebuild "switch") diff

[group("system")]
upgrade: build (rebuild "boot") topgrade diff

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
git:
    lazygit

[group("helper")]
edit:
    $EDITOR .

[group('info')]
manual:
    man configuration.nix

[group("info")]
repl:
    colmena repl

[group('info')]
list *F:
    nvd list -r /nix/var/nix/profiles/system {{ F }}

[group("info")]
diff n="1":
    #!/usr/bin/env bash
    readarray -t lines < <( find /nix/var/nix/profiles | tail -n $(({{ n }} + 2)) )
    nvd diff ${lines[0]} ${lines[{{ n }}]}

[group("info")]
inputs:
    #!/usr/bin/env nu
    open ./npins/sources.json | get pins | transpose name info | get name

[group("info")]
deps:
    #!/usr/bin/env nu
    open ./npins/sources.json | get pins | table -e
