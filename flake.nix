{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    mnw.url = "github:Gerg-L/mnw/90f21dbb8e4a854be83c503c52d7dedb034c9211";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    # TODO: Remove this once the grep feature lands in nixpkgs
    fff-nvim = {
      url = "github:dmtrKovalenko/fff.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    mnw,
    neovim-nightly,
    fff-nvim,
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
        inherit (fff-nvim.packages.${pkgs.stdenv.system}) fff-nvim;
        neovim = pkgs.neovim-unwrapped;
      };
      nightly = import ./default.nix {
        inherit pkgs mnw;
        inherit (fff-nvim.packages.${pkgs.stdenv.system}) fff-nvim;
        inherit (neovim-nightly.packages.${pkgs.stdenv.system}) neovim;
      };
    });
  };
}
