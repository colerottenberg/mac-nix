{
  description = "CRotty's Darwin system flake";

  inputs = {
    # Where we retrieve nixpkgs from. Giant mono repo with all the packages.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # nixpkgs-unstable is the rolling release channel and security patches are applied to it.

    # Nix-darwin is a tool for managing darwin configuration using nix.
    # Nix-darwin works on a systems level, while home-manager works on a user level.
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager is a tool for managing user configuration using nix.
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    darwinConfigurations.Coles-MacBook-Pro-3 = inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        ({ pkgs, ... }: {
          programs.zsh.enable = true;
          environment.shells = [ pkgs.zsh pkgs.bash pkgs.fish ];
          environment.loginShell = pkgs.zsh;
          environment.systemPackages =
            [
              pkgs.coreutils
              pkgs.clang
              pkgs.wget
              pkgs.curl
              pkgs.vim
              pkgs.neovim
              pkgs.git
              pkgs.ripgrep
              pkgs.fzf
              pkgs.zsh # default shell on catalina
              pkgs.cmake
            ];
          # Enabling Sudo with Touch ID
          security.pam.enableSudoTouchIdAuth = true;
          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          # nix.package = pkgs.nix;

          # Remapping the caps lock key to control
          system.keyboard.remapCapsLockToControl = true;

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

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 4;

          # Setting users and user home
          users.users.colerottenberg = {
            name = "colerottenberg";
            home = "/Users/colerottenberg";
          };


        })
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.colerottenberg.imports = [
              ({ pkgs, ... }: {
                # Use home state version of latest home-manager release
                home.stateVersion = "24.11";

                # Home packages
                home.packages = with pkgs; [
                  # Terminal
                  zsh
                  bash
                  fish
                  # Tools
                  coreutils
                  clang
                  wget
                  curl
                  vim
                  neovim
                  git
                  ripgrep
                  fzf
                  cmake
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
                programs.bat.enable = true;
                programs.bat.config.theme = "TwoDark";
                programs.home-manager.enable = true;
              })
            ];
          };
        }
      ];
    };
  };
}
