{ config, ... }:

{
  launchd.user.agents.keyboard-remap = {
    serviceConfig = {
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--set"
        (builtins.toJSON {
          UserKeyMapping = config.system.keyboard.userKeyMapping;
        })
      ];
      RunAtLoad = true;
    };
  };
}

