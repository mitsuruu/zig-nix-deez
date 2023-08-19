{
  inputs = {
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = {self, nixpkgs-unstable, flake-utils}:
		with flake-utils.lib; eachSystem allSystems (system: {
    packages = rec {
      zig-nix-deez = with import nixpkgs-unstable { inherit system; }; stdenv.mkDerivation {
				name = "zig-nix-deez";
				src = ./.;
				buildInputs = [ zig ];
				buildPhase = ''
					export ZIG_LOCAL_CACHE_DIR=$(pwd)/zig-cache
					export ZIG_GLOBAL_CACHE_DIR=$ZIG_LOCAL_CACHE_DIR
					zig build $ADDITIONAL_FLAGS
				'';
				installPhase = ''
					mkdir -p $out/bin
					cp zig-out/bin/zig-nix-deez $out/bin/
				'';
			};
      default = zig-nix-deez;
    };
  });
}