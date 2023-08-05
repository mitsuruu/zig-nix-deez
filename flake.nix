{
  inputs = {
    zicross.url = github:flyx/Zicross;
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = {self, zicross, nixpkgs, flake-utils}:
      with flake-utils.lib; eachSystem allSystems (system: let
    pkgs = import nixpkgs {
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
  });
}