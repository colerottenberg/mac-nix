# Makefile for Nix Darwin and Home-manager

default: help

help:
	@echo "make install"
	@echo "    Install Nix Darwin and Home-manager"
	@echo "make update"
	@echo "    Update Nix Darwin and Home-manager"
	@echo "make clean"
	@echo "    Clean Nix Darwin and Home-manager"

install:
	@echo "Installing Nix Darwin and Home-manager..."
	nix run nix-darwin --experimental-features 'nix-command flakes' -- switch --flake .

update:
	@echo "Updating Nix Darwin and Home-manager..."
	darwin-rebuild switch --flake .

clean:
	@echo "Cleaning up..."
	nix-store --gc
