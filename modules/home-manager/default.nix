{ pkgs, ... }: {
  # Use home state version of latest home-manager release
  home.stateVersion = "24.11"; # Update this to the latest version of home-manager

  # Home packages
  home.packages = with pkgs; [
    # Terminal
    zsh
    bash
    fish
    # Tools
    coreutils
    wget
    curl
    vim
    neovim
    git
    ripgrep
    fzf
    cmake
    avrdude
    influxdb2-cli
    # Productivity Tools
    # Cool TUIs I like to use
    lazygit
    lazydocker
    zoxide
    eza
    # Languages
    # Python
    python3
    python3Packages.pip
    pipx
    poetry
    pdm
    pyenv
    # Rust
    rustup # Rust: need to run `rustup-init` after install
    # C/C++
    clang
    # Just: a command runner
    just # Just: a command runner
    # WebDev
    bun
    # Fonts
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Iosevka"
        "IosevkaTerm"
        "Meslo"
        "JetBrainsMono"
      ];
    })
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  # Progams enables
  # Bat: A cat clone with wings
  programs.bat.enable = true;
  programs.bat.config.theme = "gruvbox-dark";
  programs.home-manager.enable = true;
  # Zoxide: A smarter cd command
  programs.zoxide.enable = true;
  # Managed Git Config
  programs.git = {
    enable = true;
    userName = "Cole Rottenberg";
    userEmail = "cole.rottenberg@gmail.com";
  };

  # TexLive Management
  programs.texlive = {
    enable = true;
  };

  # Configure Neovim
  # programs.neovim = { };

  # Configuring starship prompt
  programs.starship = {
    enable = true;
  };
  # Configuration Settings

  # Starship Configuration
  # home.file.".config/starship.toml".source = ./starship.toml;

  # AeroSpace WM Configuration
}
