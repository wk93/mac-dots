{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}: let
  user = "wojtek";
in {
  imports = [
    ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
    # onActivation.cleanup = "uninstall";

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
    masApps = {
      # "wireguard" = 1451685025;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      imports = [
        ./symlinks.nix
      ];
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        stateVersion = "23.11";
      };
      home.sessionVariables = {
        CHROME_EXECUTABLE = "/Applications/Chromium.app/Contents/MacOS/Chromium";
      };
      programs = {} // import ../shared/home-manager.nix {inherit config pkgs lib;};

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock = {
    enable = true;
    username = user;
    entries = [
      {path = "/Applications/Brave Browser.app/";}
      {path = "/System/Applications/Messages.app/";}
      {path = "/Applications/Ghostty.app/";}
      # { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
      {path = "/Applications/Spotify.app/";}
      {path = "/System/Applications/System Settings.app/";}
      {
        path = "${config.users.users.${user}.home}/Downloads";
        section = "others";
        options = "--sort name --view grid --display stack";
      }
    ];
  };
}
