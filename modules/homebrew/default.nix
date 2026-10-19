{
  enable = true;
  onActivation.cleanup = "uninstall";
  casks = import ./casks.nix;
  brews = import ./brews.nix;
  masApps = import ./mas.nix;
}
