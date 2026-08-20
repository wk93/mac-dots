{
  pkgs,
  lib,
  user,
  inputs,
  ...
}: {
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
      # herdr z osobnego, świeższego nixpkgs (patrz flake.nix input nixpkgs-herdr).
      (_final: prev: {
        inherit (inputs.nixpkgs-herdr.legacyPackages.${prev.stdenv.hostPlatform.system}) herdr;
      })
    ];
  };

  nix.enable = false;

  programs.zsh.enable = true;

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  system = {
    stateVersion = 5;
    primaryUser = user;
    checks.verifyNixPath = false;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder._FXShowPosixPathInTitle = false;

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };

  homebrew = import ./homebrew;

  launchd.user.agents.herdr = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-l"
        "-c"
        "cd ~ && ${pkgs.herdr}/bin/herdr server"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      EnvironmentVariables = {
        PATH =
          lib.makeBinPath [
            "/run/current-system/sw"
            "/nix/var/nix/profiles/default"
          ]
          + ":/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
