{pkgs}:
with pkgs; [
  # General
  neovim
  bat
  coreutils
  killall
  wget
  zip
  unzip

  # Encryption
  age
  gnupg
  git-crypt

  # Media
  fd
  meslo-lgs-nf
  ffmpeg

  # Text and terminal utilities
  jq
  mongosh
  ripgrep
  tree

  # Development tools
  curl
  gh
  lazygit
  fzf
  (direnv.overrideAttrs { doCheck = false; })
  wrangler
  claude-code

  # Languages and runtimes
  nodejs_24
  eas-cli
  bun
  cocoapods
  rustup

  # LSP / formatters
  vtsls
  prettierd
  lua-language-server
  stylua
  alejandra
  tailwindcss-language-server
  vscode-langservers-extracted
]
