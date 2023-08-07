{
  inputs = {
    zicross.url = github:flyx/Zicross;
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = {self, zicross, nixpkgs-unstable, flake-utils}:
      with flake-utils.lib; eachSystem allSystems (system: let
    pkgs = import nixpkgs-unstable {
      inherit system;
      overlays = [
        zicross.overlays.zig
      ];
    };
  in rec {
    packages = rec {
      zig-nix-deez = pkgs.buildZig {
        buildInputs = [ ];
        pname = "zig-nix-deez";
        version = "0.1.0";
        src = ./.;
        zigExecutables = [
          {
            name = "zig-nix-deez";
            file = "main.zig";
            install = true;
          }
        ];
        zigTests = [
        ];
        meta = {
          maintainers = [ "Yamamech <30635996+yamamech@users.noreply.github.com>" ];
          description = "zig-nix-deez";
        };
      };
      default = zig-nix-deez;
    };
    overlay = final: prev: {
      zig-nix-deez = pkgs.callPackage self.packages.zig-nix-deez;
    };
  });
}