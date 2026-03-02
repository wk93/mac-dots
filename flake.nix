{
  description = "Minimal macOS configuration (nix-darwin + home-manager)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
  };

  outputs = inputs @ {
    darwin,
    home-manager,
    ...
  }: let
    system = "aarch64-darwin";
    user = "wojtek";
    fullName = "Wojciech Kania";
    email = "wojtek@kania.sh";
  in {
    darwinConfigurations.nautilus = darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit inputs user fullName email;};
      modules = [
        ./modules/system.nix
        ./modules/home.nix
        home-manager.darwinModules.home-manager
      ];
    };
  };
}
