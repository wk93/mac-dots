# mac-dots

Prosta konfiguracja **tylko dla macOS** oparta o:

- `nix-darwin`
- `home-manager`
- `nix-homebrew`
- `neovim-nightly-overlay` (dla nightly Neovima)

## Struktura

- `flake.nix` – wejście do konfiguracji i definicja hosta `macos`.
- `modules/system.nix` – ustawienia systemowe macOS + Homebrew.
- `modules/home.nix` – konfiguracja użytkownika przez Home Manager.
- `modules/programs.nix` – konfiguracja programów CLI (zsh, git, ssh).
- `modules/packages.nix` – pakiety instalowane przez Nix.
- `modules/brews.nix` i `modules/casks.nix` – pakiety Homebrew.
- `modules/symlinks.nix` – symlinki do katalogu `config/`.
- `config/` – pliki konfiguracyjne aplikacji (nvim, ghostty, ...).

## Użycie

### Update

```bash
  nix flake update
```

### Rebuild

```bash
rebuild
# lub
sudo darwin-rebuild switch --flake ~/.dotfiles
```

Sudo bez hasła przez Touch ID (`security.pam.services.sudo_local`).

## Window management

Tiling WM: **AeroSpace** (SIP-free, bez scripting addition) + **Karabiner-Elements**.
Zastępuje wcześniejsze yabai + skhd.

- Konfiguracja AeroSpace (workspace'y, reguły, bindy) w `modules/aerospace.nix`
  (TOML generowany przez `services.aerospace`).
- Modyfikator "Super" = **lewy Option**. Karabiner mapuje lewy Option → `ctrl+alt`
  (`config/karabiner/karabiner.json`), więc AeroSpace binduje `ctrl-alt-*`.
  Prawy Option/AltGr zostaje wolny dla polskich znaków.

### Skróty (Super = lewy Option)

- `Super+1..9` – workspace 1..9
- `Super+Shift+1..9` – przenieś okno na workspace + podążaj
- `Super+Enter` – Ghostty, `Super+B` – Brave, `Super+P` – 1Password, `Super+Q` – zamknij okno
- `Super+H/J/K/L` – focus, `Super+Shift+H/J/K/L` – przenieś okno w layoucie

### Uprawnienia macOS (jednorazowo, ręcznie)

- **AeroSpace** → System Settings → Privacy & Security → **Accessibility**
- **Karabiner-Elements** → **Input Monitoring** + zatwierdzenie sterownika (System Extension / DriverKit)
