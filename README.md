# mac-dots

Prosta konfiguracja **tylko dla macOS** (host `nautilus`, `aarch64-darwin`) oparta o:

- `nix-darwin`
- `home-manager`
- `nix-homebrew` (Homebrew z Nixa, niemutowalne tapy)
- `neovim-nightly-overlay` (dla nightly Neovima)

## Struktura

- `flake.nix` – wejście do konfiguracji, definicja hosta `nautilus`, tapy Homebrew.
- `modules/system.nix` – ustawienia systemowe macOS, overlaye, sshd, Touch ID dla sudo.
- `modules/aerospace.nix` – tiling WM (AeroSpace).
- `modules/home.nix` – konfiguracja użytkownika przez Home Manager.
- `modules/programs.nix` – konfiguracja programów CLI (zsh, git, ssh).
- `modules/packages.nix` – pakiety instalowane przez Nix.
- `modules/claude-code-pin.nix` – przypięta wersja Claude Code (bumpowana przez CI).
- `modules/homebrew/` – pakiety Homebrew (`brews.nix`, `casks.nix`, `mas.nix`).
- `modules/patches/` – patche do pakietów z nixpkgs (np. `mosh-faint.patch`).
- `modules/symlinks.nix` – symlinki do katalogu `config/`.
- `config/` – pliki konfiguracyjne aplikacji (nvim, ghostty, herdr, karabiner).
- `secrets/` – szyfrowane git-crypt (`env.zsh` z tokenami, fonty).

## Użycie

### Update

```bash
nix flake update
```

Aktualizuje też brew i caski (tapy są inputami flake'a).

### Rebuild

```bash
rebuild
# lub
sudo darwin-rebuild switch --flake ~/.dotfiles
```

Sudo bez hasła przez Touch ID (`security.pam.services.sudo_local`).

### Sekrety

Po sklonowaniu: `git-crypt unlock` (potrzebny klucz git-crypt). Do tego czasu
`secrets/` to zaszyfrowane bloby – zsh spróbuje zsourcować binarny `env.zsh`
(błędy przy starcie shella), a symlink fontów TX-02 wskaże na śmieci.

### Nowy tap Homebrew

1. Dodaj input `*-tap` (`flake = false`) w `flake.nix`.
2. Dopisz go do `nix-homebrew.taps` – `homebrew.taps` liczy się z tego automatycznie.
3. Cask/brew podaj z pełną nazwą (`owner/tap/nazwa`).

## CI (GitHub Actions)

- `check.yml` – `nix flake check`, `nix fmt -- --check`, build systemu darwin.
- `update-claude.yml` – codziennie bumpuje `modules/claude-code-pin.nix`
  (`scripts/update-claude.sh`) i otwiera PR.

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

## Terminal

- **Ghostty** + **herdr** (multiplexer, prefix `C-a` jak w tmux, splity `prefix+|` / `prefix+-`).
  Linkowany jest tylko `config/herdr/config.toml` – herdr trzyma w `~/.config/herdr` stan runtime.
- Neovim: nawigacja między splitami nvim i panelami herdr (`plugins/herdr-navigation.lua`),
  integracja z Claude Code przez `claudecode.nvim` (`<leader>a*`, diff accept/deny).

## Zdalny dostęp (mosh przez Tailscale)

- `services.openssh` – sshd tylko na klucze, bez roota, `AllowUsers` = nasz user.
  Klucze klientów w `users.users.<user>.openssh.authorizedKeys.keys` (jeden per urządzenie).
- `mosh` z patchem przywracającym SGR 2 (faint/dim) – inaczej wyszarzone podpowiedzi
  Claude Code wyglądają jak wpisany tekst.
- `LANG=en_US.UTF-8` globalnie – `mosh-server` startuje przez nieinteraktywne ssh
  i bez UTF-8 odmawia startu.
