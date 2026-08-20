{
  config,
  lib,
  ...
}: {
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/nvim";

  home.file.".config/ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/ghostty";

  # Tylko config.toml — herdr trzyma w ~/.config/herdr także stan runtime
  # (plugins/), więc katalogu NIE linkujemy.
  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/herdr/config.toml";

  # Karabiner: lewy Option -> ctrl+alt (Super dla AeroSpace). Plik w repo jest
  # zapisywalny, więc Karabiner może dopisać swoje defaulty (symlink przetrwa).
  home.file.".config/karabiner/karabiner.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/karabiner/karabiner.json";

  home.file."Library/Fonts/TX-02".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/secrets/fonts/TX-02";
}
