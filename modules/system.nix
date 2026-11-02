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
    # Klucz per urządzenie klienckie (prywatny zostaje na urządzeniu).
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqWXVV1DBPYBYNM8Ob/Q2/I3cclDzZmVRwOYRwAy9sj T480"
    ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
      # herdr z osobnego, świeższego nixpkgs (patrz flake.nix input nixpkgs-herdr).
      (_final: prev: {
        inherit (inputs.nixpkgs-herdr.legacyPackages.${prev.stdenv.hostPlatform.system}) herdr;
      })
      # mosh 1.4.0 gubi SGR 2 (faint/dim) - np. wyszarzone podpowiedzi Claude Code wyglądają jak wpisany tekst.
      (_final: prev: {
        mosh = prev.mosh.overrideAttrs (old: {
          patches = (old.patches or []) ++ [./patches/mosh-faint.patch];
        });
      })
    ];
  };

  nix.enable = false;

  programs.zsh.enable = true;

  # mosh-server startuje przez nieinteraktywne ssh, bez initExtra - bez UTF-8 odmawia startu.
  environment.variables.LANG = "en_US.UTF-8";

  # Remote Login (sshd) dla mosh przez Tailscale - tylko klucze, tylko nasz user.
  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
      KbdInteractiveAuthentication no
      PermitRootLogin no
      AllowUsers ${user}
    '';
  };

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
