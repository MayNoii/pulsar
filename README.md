# pulsar

## My personal NixOS configuration

This is the dotfiles repo for NixOS. It is named pulsar because my previous
config was named nova, as in, a supernova. After a star explodes in a supernova,
one the possible results is a pulsating neutron star, or pulsar.

## Tooling

This repo uses `nilla` for dependency management, which is a very experimental
tool with currently pretty bad documentation.

~~Actual deployment is managed by `colmena`. The colmena-nilla wiring is very
simple, and might change at some point.~~

Deployment is managed by the `saturn.nix` file, see the `justfile` for details.

Do not expect the code in this repo to be any good.

## Structure

`npins/` is the default npins directory. `nilla.nix` gets all its inputs
directly from npins, and imports the `nilla/` directory which contains most
regular outputs.

`hive.nix` then calls `import ./nilla.nix` to get its instance of nixpkgs, as
well as other inputs.

`nodes/` is a directory where each subdirectory is a different host. Currently,
there is only one, because I am poor.

`modules/` contains NixOS modules that are universally applied to every host.
Since I currently only have one host, what is and is not made into a module is
pretty arbitrary, so far.

## Nia

There is a `justfile` containing some common commands I use for maintaining this
repository. My system configuration defines a `nia` command that wraps over said
Justfile.
