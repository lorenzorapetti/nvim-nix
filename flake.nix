{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/ff335ced3ea3c449a848741de9d59f3f02b0a774";
    mnw.url = "github:Gerg-L/mnw";
  };
  outputs = {
    nixpkgs,
    mnw,
    ...
  }: let
    lib = nixpkgs.lib;
    supportedSystems = ["x86_64-linux" "aarch64-darwin"];
    forAllSystems = function:
      lib.genAttrs
      supportedSystems
      (system: function nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (pkgs: {
      default = import ./default.nix {inherit pkgs mnw;};
    });
  };
}
