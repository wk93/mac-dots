{pkgs}:
with pkgs; [
  # General packages for development and system management
  alacritty
  neovim
  bat
  coreutils
  killall
  openssh
  wget
  zip

  # Encryption and security tools
  age
  gnupg
  git-crypt

  # Cloud-related tools and SDKs
  # docker
  # docker-compose

  # Media-related packages
  fd
  meslo-lgs-nf
  ffmpeg

  # Text and terminal utilities
  jq
  mongosh
  ripgrep
  tree
  tmux
  unzip

  # Development tools
  curl
  gh
  lazygit
  fzf
  (direnv.overrideAttrs { doCheck = false; })
  wrangler
  claude-code

  # Programming languages and runtimes
  nodejs_24
  eas-cli
  bun
  cocoapods
  rustup

  # LSP
  vtsls
  prettierd
  lua-language-server
  stylua
  alejandra
  tailwindcss-language-server
  vscode-langservers-extracted

  # Python packages
  # python3
  # virtualenv
]
