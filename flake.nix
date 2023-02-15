# The flake file is the entry point for nix commands
{
  description = "A reproducible Nix package set for Chia";

  # Inputs are how Nix can use code from outside the flake during evaluation.
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.cat-admin-tool.url = "github:Chia-Network/CAT-admin-tool";
  inputs.cat-admin-tool.flake = false;

  # Outputs are the public-facing interface to the flake.
  outputs = { self, flake-parts, nixpkgs, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];

      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { final, prev, ... }: {
        overlayAttrs = import ./overlay.nix inputs final prev;

        formatter = final.nixpkgs-fmt;
        packages = final.chiaNix;
      };
    };
}
