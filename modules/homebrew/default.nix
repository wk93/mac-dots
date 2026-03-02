{
  enable = true;
  onActivation.cleanup = "uninstall";
  taps = import ./taps.nix;
  casks = import ./casks.nix;
  brews = import ./brews.nix;
  masApps = import ./mas.nix;
}
