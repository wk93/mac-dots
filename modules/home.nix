{ user, fullName, email, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${user} = { pkgs, config, lib, ... }: {
      imports = [ ./symlinks.nix ];

      home = {
        stateVersion = "23.11";
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
      };

      home.sessionVariables = {
        CHROME_EXECUTABLE = "/Applications/Chromium.app/Contents/MacOS/Chromium";
      };

      programs = import ./programs.nix {
        inherit pkgs lib;
        name = fullName;
        inherit user email;
      };

      manual.manpages.enable = false;
    };
  };
}
