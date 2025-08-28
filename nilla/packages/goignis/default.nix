# First, the named parameters.
{
  # you almost always want to depend on lib
  lib,

  # these are Nixpkgs functions that your package uses
  buildGoModule,
  fetchFromGitHub,

# more dependencies would go here...
}: # this means end of named parameters

# Now, the definition of your package.
# This should be something that produces a derivation, not
# a string or a raw attribute set or anything else.
# buildGoModule is a function that returns a derivation, so
# you want `buildGoModule ...` here, not `{ pet = ...; }` here;
# the latter is an attribute set.

buildGoModule {
  pname = "goignis";
  version = "dev";

  src = fetchFromGitHub {
    owner = "ignis-sh";
    repo = "goignis";
    rev = "main";
    hash = "sha256-47zXTU0G/f9YvEVhg7qDHDXw2vcbdkVQaZ5QyB6JUng=";
  };

  # this hash is updated from the example, which seems to be out of date
  vendorHash = "sha256-y3B3qFpxnnBe2HhO5u0sXYPOKJ0+akBEiN6oCSDETXM=";

  doCheck = false;

  meta = {
    description = " An optional, high-performance CLI for the Ignis widget framework";
    homepage = "https://github.com/ignis-sh/goignis";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ kalbasit ];
  };
}
