# ~/.config/nix/flake.nix

{
	description = "My system configuration";
	
	inputs = {
		# Used to install packages 
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		# Used to work with MacOS 
		nix-darwin = {
			url = "github:LnL7/nix-darwin";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	
	outputs = inputs@{ self, nix-darwin, nixpkgs }:
	let
		configuration = {pkgs, ... }: {
		
			services.nix-daemon.enable = true;
			# Necessary for using flakes on this system.
			nix.settings.experimental-features = "nix-command flakes";
		
			system.configurationRevision = self.rev or self.dirtyRev or null;
		
			# Used for backwards compatibility. please read the changelog
			# before changing: `darwin-rebuild changelog`.
			system.stateVersion = 4;
		
			# The platform the configuration will be used on.
			# If you're on apple silicone,  replace with "aarch64-darwin"
			nixpkgs.hostPlatform = "x86_64-darwin";
		
			# Declare the user that will be running `nix-darwin`.
			users.users.nikita = {
				name = "nikita";
				home = "/Users/nikita";
		};
	
		# Create /etc/zshrc that loads the nix-darwin environment.
		programs.zsh.enable = true;
	
		# This attribute is a list of packages to install.
		# Lists in Nix are space-separated.
		# pkgs refers to nixpkgs - the standard repository for Nix
		# packages are called derivations within nixpkgs
		#
		environment.systemPackages = [pkgs.neofetch];
		
		homebrew = {
			enable = true;
			# This option makes the home-brew config declarative.
			# Only packages specified in this file will be installed. 
			# Packages not in the declared list will be removed
			# when you reload with `darwin-rebuild switch`.
			#onActivation.cleanup = "uninstall";
		
			taps = [];
			brews = [];
			casks = [];
		};
		
		# Used for enabling Touch ID for `sudo`
		# so you don't have to keep entering your password every rebuild.
		security.pam.enableSudoTouchIdAuth = true;
		};
	
	in
	{
		darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
			modules = [
			 configuration
			];
		};
	};
}
