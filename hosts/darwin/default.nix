args @ {
  config,
  pkgs,
  ...
}: let
  user = "wojtek";
in {
  imports = [
    ../../modules/fonts.nix
    ../../modules/home-manager.nix
    ../../modules/keyboard-remap.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

    overlays =
      # Apply each overlay found in the /overlays directory
      let
        path = ../../overlays;
      in
        with builtins;
          map (n: import (path + ("/" + n)))
          (filter (n:
            match ".*\\.nix" n
            != null
            || pathExists (path + ("/" + n + "/default.nix")))
          (attrNames (readDir path)))
          ++ [
            # overlays
            args."neovim-nightly-overlay".overlays.default
          ];
  };

  nix.enable = false;

  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 5;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        KeyRepeat = 2; # Values: 120, 90, 60, 30, 12, 6, 2
        InitialKeyRepeat = 15; # Values: 120, 94, 68, 35, 25, 15

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

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };
}
