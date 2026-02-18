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

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    mhaeuser-tap = {
      url = "github:mhaeuser/homebrew-mhaeuser";
      flake = false;
    };
    asmvik-tap = {
      url = "github:asmvik/homebrew-formulae";
      flake = false;
    };
    jackielii-tap = {
      url = "github:jackielii/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs @ { darwin, home-manager, nix-homebrew, ... }: let
    system = "aarch64-darwin";
    user = "wojtek";
    fullName = "Wojciech Kania";
    email = "wojtek@kania.sh";
  in {
    darwinConfigurations.macos = darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs user fullName email; };
      modules = [
        ./modules/system.nix
        ./modules/home.nix
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            inherit user;
            enable = true;
            mutableTaps = false;
            autoMigrate = true;
            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
              "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
              "mhaeuser/homebrew-mhaeuser" = inputs.mhaeuser-tap;
              "asmvik/homebrew-formulae" = inputs.asmvik-tap;
              "jackielii/homebrew-tap" = inputs.jackielii-tap;
            };
          };
        }
      ];
    };
  };
}
