## Shared
Much of the shared shell/editor tooling used on Darwin is found here.

This configuration gets imported by the Darwin module. Some configuration examples include `git`, `zsh`, `vim`, and `tmux`.

## Layout
```
.
├── config             # Config files not written in Nix
├── cachix             # Defines cachix, a global cache for builds
├── default.nix        # Defines how we import overlays
├── files.nix          # Non-Nix, static configuration files (now immutable!)
├── home-manager.nix   # The goods; most all shared config lives here
├── packages.nix       # List of packages to share

```
