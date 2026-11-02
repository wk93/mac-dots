{pkgs}: let
  claudePin = import ./claude-code-pin.nix;
in
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
    poppler-utils

    # Text and terminal utilities
    herdr
    jq
    mongosh
    mosh
    ripgrep
    tree

    # Development tools
    curl
    gh
    lazygit
    fzf
    (direnv.overrideAttrs {doCheck = false;})
    wrangler
    (stdenvNoCC.mkDerivation rec {
      pname = "claude-code";
      version = claudePin.version;
      src = fetchurl {
        url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${version}/darwin-arm64/claude";
        hash = claudePin.hash;
      };
      dontUnpack = true;
      dontBuild = true;
      dontStrip = true;
      __noChroot = true;
      nativeBuildInputs = [makeBinaryWrapper];
      installPhase = ''
        install -Dm755 $src $out/bin/claude
        wrapProgram $out/bin/claude \
          --set DISABLE_AUTOUPDATER 1 \
          --set-default FORCE_AUTOUPDATE_PLUGINS 1 \
          --set DISABLE_INSTALLATION_CHECKS 1 \
          --set USE_BUILTIN_RIPGREP 0 \
          --prefix PATH : ${lib.makeBinPath [ripgrep procps]}
      '';
      meta.mainProgram = "claude";
    })

    # Languages and runtimes
    nodejs_24
    eas-cli
    bun
    cocoapods
    rustup
    uv

    # LSP / formatters
    vtsls
    prettierd
    lua-language-server
    stylua
    alejandra
    tailwindcss-language-server
    vscode-langservers-extracted
  ]
