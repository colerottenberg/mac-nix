# MacOS Nix Configuration

### *WARNING*
This project is currently and work in progress as I learn more about Nix and how to more efficiently configure my system using Nix.

This project is meant to hold all of my MacOS configurations using the Nix package manager.
The project uses two Nix packages: Nix-Darwin **and** Home-Manager to manager both my System and User configurations.

To start, first install **Nix** using the following command:

## Setup

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Then start by cloning this repo to the following way:

```bash
git clone git@github.com:colerottenberg/mac-nix.git ~/.config/mac-nix
```

## Common Issues with Personalization:

Often the name of the device will change according to the type of device. In this case it is important to change the of the `darwinConfigurations.<HOSTNAME>` to your hostname. Another area might include changing the name of the users names defined in by: 
```nix
          users.users.<USERNAME> = {
            name = "<USERNAME>";
            description = "<FULL NAME>";
            home = "/Users/<USERNAME>";
          };
```

As well is in the Home-Manager section:
```nix
            users.colerottenberg.imports = [ <...>
```

Besided these two simple changes, correcting the `home.stateVersion = <VERSION>` might be necessary to match the Nix-Darwin packages with the current *unstable* package repository.

## Installation

And then run the following command to start the installation of the system. This will require Superuser/Admin privileges.

```bash
nix run nix-darwin --experimental-feature nix-command --experimental-feature flakes -- switch --flake ~/.config/mac-nix
```
