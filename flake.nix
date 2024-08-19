{
  description = "CRotty's Darwin system flake";

  inputs = {
    # Where we retrieve nixpkgs from. Giant mono repo with all the packages.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # nixpkgs-unstable is the rolling release channel and security patches are applied to it.

    # Nix-darwin is a tool for managing darwin configuration using nix.
    # Nix-darwin works on a systems level, while home-manager works on a user level.
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager is a tool for managing user configuration using nix.
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
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
            # pkgs.zsh # default shell on catalina
            pkgs.cmake
            pkgs.home-manager
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

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true; # default shell on catalina
        # programs.fish.enable = true;

        # Default login shell for users.
        environment.shells = [ pkgs.zsh pkgs.bash pkgs.fish ];
        environment.loginShell = pkgs.zsh;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations.Coles-MacBook-Pro-3 = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.Coles-MacBook-Pro-3.pkgs;
    };
}
