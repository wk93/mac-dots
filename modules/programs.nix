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

      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH

      export HISTIGNORE="pwd:ls:cd"
      export ALTERNATE_EDITOR=""
      export EDITOR="nvim"
      export VISUAL="nvim"

      shell() {
        nix-shell '<nixpkgs>' -A "$1"
      }

      alias diff=difft
      alias ls='ls --color=auto'

      if [[ -z "$TMUX" && -n "$GHOSTTY_RESOURCES_DIR" && $- == *i* ]]; then
        tmux new-session -A -s main
      fi
    '';
  };

  git = {
    enable = true;
    ignores = ["*.swp"];
    lfs.enable = true;
    signing = {
      key = "~/.ssh/keys/git_sign.pub";
      signByDefault = true;
    };
    settings = {
      user.name = name;
      user.email = email;
      user.signingKey = "~/.ssh/keys/git_sign.pub";
      init.defaultBranch = "master";
      core.editor = "vim";
      core.autocrlf = "input";
      gpg.format = "ssh";
      commit.gpgSign = true;
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
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/keys/git_auth";
        identitiesOnly = true;
      };
    };
  };

  tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      yank
      prefix-highlight
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'macchiato'
          set -g @catppuccin_window_status_style "rounded"

          # Window
          set -g @catppuccin_window_text " #{window_name}"
          set -g @catppuccin_window_current_text " #{window_name}"

          # Session
          set -g @catppuccin_session_icon " "
          set -g @catppuccin_session_color "#{@thm_green}"

          # Directory - basename only
          set -g @catppuccin_directory_icon " "
          set -g @catppuccin_directory_text "#{b:pane_current_path}"
          set -g @catppuccin_directory_color "#{@thm_lavender}"

          # Host
          set -g @catppuccin_host_icon " "
          set -g @catppuccin_host_color "#{@thm_blue}"
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5'
        '';
      }
    ];
    terminal = "tmux-256color";
    prefix = "C-a";
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"

      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on
      setw -g automatic-rename on
      set -g automatic-rename-format "#{pane_current_command}"

      set -g focus-events on
      set -g mouse on

      setw -g mode-keys vi
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      unbind C-b
      unbind '"'
      unbind %

      bind-key c new-window -c "#{pane_current_path}"
      bind-key | split-window -h -c "#{pane_current_path}"
      bind-key - split-window -v -c "#{pane_current_path}"
      bind-key a last-window

      # Resize panes (C-a H/J/K/L)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Zoom/maximize pane (C-a m) - toggle
      bind m resize-pane -Z

      # Status bar (po załadowaniu catppuccin)
      set -g status-position top
      set -g status-left "#{E:@catppuccin_status_session}"
      set -g status-right "#{E:@catppuccin_status_directory}#{E:@catppuccin_status_host}"
      set -g status-right-length 100
      set -g status-left-length 100
    '';
  };
}
