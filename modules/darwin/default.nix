{ pkgs, ... }: {
  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh pkgs.bash pkgs.fish ];
  environment.loginShell = pkgs.zsh;
  environment.systemPackages =
    [
      pkgs.wget
      pkgs.curl
      pkgs.vim
      pkgs.neovim
      pkgs.git
      pkgs.ripgrep
      pkgs.fzf
    ];
  # Enabling Sudo with Touch ID
  security.pam.enableSudoTouchIdAuth = true;
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Remapping the caps lock key to control
  # system.keyboard.enableKeyMapping = true;
  # system.keyboard.remapCapsLockToControl = true;
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Auto hide the dock
  system.defaults.dock.autohide = true;

  # Installing Nerd Fonts for terminal but only specific fonts
  fonts.packages = with pkgs; [
    (pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "Iosevka"
        "IosevkaTerm"
        "Meslo"
        "JetBrainsMono"
      ];
    })
  ];

  # Managing Homebrew packages
  homebrew =
    {
      enable = true;
      # Adding Homebrew Casks
      casks = [
        "neovide"
        "skim"
        "raycast"
        "appflowy"
        # "google-chrome"
        # "visual-studio-code"
        # "wezterm"
      ];
      # Adding Homebrew taps
      taps = [
        # "homebrew/cask-fonts"
      ];
      # Adding Homebrew brews

      brews = [
        "sqlite"
      ];
    };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Setting users and user home
  users.users.colerottenberg = {
    name = "colerottenberg";
    description = "Cole Rottenberg";
    home = "/Users/colerottenberg";
  };


}
