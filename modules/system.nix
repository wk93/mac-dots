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

  # Tailscale + Mullvad: rozszerzenie Tailscale wiąże sockety z fizycznym interfejsem
  # (omija tunel Mullvada → firewall Mullvada blokuje). Bind wg trasy = przez tunel.
  environment.etc."tailscale/tailscaled-env.txt".text = ''
    TS_BIND_TO_INTERFACE_BY_ROUTE=true
  '';

  # Firewall Mullvada (anchor "mullvad") blokuje tailnet 100.64.0.0/10.
  # Anchory "com.apple/*" są ewaluowane przed "mullvad", więc pass quick tutaj wygrywa.
  # Wychodzące do tailnetu: wszystko. Przychodzące z tailnetu: tylko ssh + mosh, reszta drop.
  environment.etc."pf.anchors/tailscale".text = ''
    pass out quick inet from any to 100.64.0.0/10 flags any keep state
    pass out quick inet6 from any to fd7a:115c:a1e0::/48 flags any keep state
    pass in quick inet proto tcp from 100.64.0.0/10 to any port 22 flags S/SA keep state
    pass in quick inet6 proto tcp from fd7a:115c:a1e0::/48 to any port 22 flags S/SA keep state
    pass in quick inet proto udp from 100.64.0.0/10 to any port 60000:61000 keep state
    pass in quick inet6 proto udp from fd7a:115c:a1e0::/48 to any port 60000:61000 keep state
    block drop in quick inet from 100.64.0.0/10 to any
    block drop in quick inet6 from fd7a:115c:a1e0::/48 to any
  '';

  launchd.daemons.pf-tailscale.serviceConfig = {
    ProgramArguments = ["/sbin/pfctl" "-a" "com.apple/tailscale" "-f" "/etc/pf.anchors/tailscale"];
    RunAtLoad = true;
    StartInterval = 300;
  };

  # Firewall aplikacyjny macOS: podpisane przez Apple (sshd) przechodzą, reszta pyta/blokuje.
  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
    allowSigned = true;
    allowSignedApp = false;
  };

  # mosh-server z nixa nie jest podpisany przez Apple - jawny wyjątek (ścieżka zmienia się z wersją).
  system.activationScripts.postActivation.text = ''
    /usr/libexec/ApplicationFirewall/socketfilterfw --add ${pkgs.mosh}/bin/mosh-server >/dev/null
    /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp ${pkgs.mosh}/bin/mosh-server >/dev/null
  '';

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
