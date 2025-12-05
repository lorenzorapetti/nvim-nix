{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    mnw.url = "github:Gerg-L/mnw";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };
  outputs = {
    nixpkgs,
    mnw,
    neovim-nightly,
    ...
  }: let
    lib = nixpkgs.lib;
    supportedSystems = ["x86_64-linux" "aarch64-darwin"];
    forAllSystems = function:
      lib.genAttrs
      supportedSystems
      (system:
        function (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }));
  in {
    packages = forAllSystems (pkgs: {
      default = import ./default.nix {
        inherit pkgs mnw;
        inherit (neovim-nightly.packages.${pkgs.stdenv.system}) neovim;
      };
      stable = import ./default.nix {
        inherit pkgs mnw;
        neovim = pkgs.neovim-unwrapped;
      };
    });
  };
}
