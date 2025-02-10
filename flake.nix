{
  description = "Lab 2 AI";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    # System types to support.
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    packages = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      pyPkgs = [
        pkgs.python312Packages.notebook
        pkgs.python312Packages.numpy
        pkgs.python312Packages.matplotlib
        pkgs.python312Packages.jupyterlab
        pkgs.python312Packages.seaborn
        pkgs.python312Packages.statsmodels
        pkgs.python312Packages.scipy
      ];
    in {
      default = pkgs.mkShell {
        packages = [(pkgs.python3.withPackages (_: pyPkgs))];
      };
    });
  };
}
