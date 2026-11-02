{
  description = "macOS dev workstation (nix-darwin + home-manager)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Osobny, świeży nixpkgs używany WYŁĄCZNIE dla herdr (nie ma go jeszcze
    # w przypiętym `nixpkgs`). Wstrzykiwany overlayem w modules/system.nix.
    nixpkgs-herdr.url = "github:nixos/nixpkgs/nixos-unstable";

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

    # Homebrew z Nixa (brew przypięty przez nix-homebrew → brew-src). Tapy
    # niemutowalne: aktualizacja brew/casków = `nix flake update`.
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    mhaeuser-tap = {
      url = "github:mhaeuser/homebrew-mhaeuser";
      flake = false;
    };
    wix-tap = {
      url = "github:wix/homebrew-brew";
      flake = false;
    };
    render-tap = {
      url = "github:render-oss/homebrew-render";
      flake = false;
    };
    keepresso-tap = {
      url = "github:gyorgysh/homebrew-keepresso";
      flake = false;
    };
  };

  outputs = inputs @ {
    nixpkgs,
    darwin,
    home-manager,
    nix-homebrew,
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
        ./modules/aerospace.nix
        ./modules/home.nix
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        ({config, ...}: {
          nix-homebrew = {
            inherit user;
            enable = true;
            mutableTaps = false;
            autoMigrate = true;
            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
              "mhaeuser/homebrew-mhaeuser" = inputs.mhaeuser-tap;
              "wix/homebrew-brew" = inputs.wix-tap;
              "render-oss/homebrew-render" = inputs.render-tap;
              "gyorgysh/homebrew-keepresso" = inputs.keepresso-tap;
            };
          };
          # Przy niemutowalnych tapach nix-darwin musi znać dokładnie te same.
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
      ];
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
