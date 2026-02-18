# mac-dots

Prosta konfiguracja **tylko dla macOS** oparta o:
- `nix-darwin`
- `home-manager`
- `nix-homebrew`

## Struktura

- `flake.nix` – wejście do konfiguracji i definicja hosta `macos`.
- `modules/system.nix` – ustawienia systemowe macOS + Homebrew.
- `modules/home.nix` – konfiguracja użytkownika przez Home Manager.
- `modules/programs.nix` – konfiguracja programów CLI (zsh, git, ssh, tmux).
- `modules/packages.nix` – pakiety instalowane przez Nix.
- `modules/brews.nix` i `modules/casks.nix` – pakiety Homebrew.
- `modules/symlinks.nix` – symlinki do katalogu `config/`.
- `config/` – pliki konfiguracyjne aplikacji.

## Użycie

```bash
nix run nix-darwin -- switch --flake .#macos
```
