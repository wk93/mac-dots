{
  pkgs,
  lib,
  name,
  user,
  email,
  ...
}: {
  zsh = {
    enable = true;
    autocd = false;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
    ];

    initContent = lib.mkBefore ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH

      for flutter_bin in /opt/homebrew/Caskroom/flutter/*/flutter/bin(N); do
        export PATH="$flutter_bin:$PATH"
      done

      if [[ -d "$HOME/Library/Android/sdk" ]]; then
        export ANDROID_HOME="$HOME/Library/Android/sdk"
        export ANDROID_SDK_ROOT="$ANDROID_HOME"
        export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
      fi

      if [[ -d "/Applications/Android Studio.app/Contents/jbr/Contents/Home" ]]; then
        export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
        export PATH="$JAVA_HOME/bin:$PATH"
      fi

      export LANG="en_US.UTF-8"
      export LC_ALL="en_US.UTF-8"

      export HISTIGNORE="pwd:ls:cd"
      export ALTERNATE_EDITOR=""
      export EDITOR="nvim"
      export VISUAL="nvim"

      # Sekrety (API tokeny, hasła CI itd.) — trzymane w secrets/env.zsh,
      # szyfrowane w repo przez git-crypt (secrets/** w .gitattributes),
      # plaintext lokalnie po odblokowaniu. Nie wyciekają na GitHub.
      [[ -f "$HOME/.dotfiles/secrets/env.zsh" ]] && source "$HOME/.dotfiles/secrets/env.zsh"

      shell() {
        nix shell "nixpkgs#$1"
      }

      alias diff=difft
      alias ls='ls --color=auto'
      alias rebuild='sudo darwin-rebuild switch --flake ~/.dotfiles'

      if [[ -z "$HERDR_PANE_ID" && -n "$GHOSTTY_RESOURCES_DIR" && $- == *i* ]]; then
        herdr
      fi
    '';
  };

  git = {
    enable = true;
    ignores = ["*.swp"];
    lfs.enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/keys/git_sign.pub";
      signByDefault = true;
    };
    settings = {
      user.name = name;
      user.email = email;
      init.defaultBranch = "master";
      core.editor = "nvim";
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = ["/Users/${user}/.ssh/config_external"];
    matchBlocks = {
      "*" = {
        sendEnv = ["LANG" "LC_*"];
        hashKnownHosts = true;
      };
      "uk-vps" = {
        hostname = "178.239.171.99";
        user = "root";
        identityFile = "~/.ssh/keys/oracle";
        identitiesOnly = true;
      };
      "oracle" = {
        hostname = "89.168.111.137";
        user = "wojtek";
        identityFile = "~/.ssh/keys/oracle";
        identitiesOnly = true;
      };
      "frog" = {
        hostname = "frog01.mikr.us";
        user = "frog";
        port = 11088;
        identityFile = "~/.ssh/keys/oracle";
        identitiesOnly = true;
      };
      "soco" = {
        hostname = "193.107.90.205";
        user = "soco";
        identityFile = "~/.ssh/keys/soco";
        identitiesOnly = true;
      };
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/keys/git_auth";
        identitiesOnly = true;
      };
    };
  };
}
