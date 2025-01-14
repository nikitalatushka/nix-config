# ~/.config/nix/flake.nix
# rebuild with `$ darwin-rebuild switch --flake ~/.config/nix`
{
    description = "Nikita's system configuration for MacBook Pro 16 (2019)";
    
    inputs = {
        # Used to install packages 
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        # Used to work with MacOS 
        nix-darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    
    outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let
        configuration = {pkgs, ... }: {
            # Nix-Darwin configs found here:
            # https://daiderd.com/nix-darwin/manual/index.html
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
            # Darwin equivalent of `scutil --set` on macOS
            networking.hostName = "mbp2019";            
            networking.computerName = "Nikita's MacBook Pro";
            networking.localHostName = "mbp2019";
    
            # Create /etc/zshrc that loads the nix-darwin environment.
            programs.zsh.enable = true;
        
            # This attribute is a list of packages to install.
            # Lists in Nix are space-separated.
            # pkgs refers to nixpkgs - the standard repository for Nix
            # packages are called derivations within nixpkgs
            environment.systemPackages = [
                pkgs.neofetch
                pkgs.neovim
                pkgs.tmux
                pkgs.mas
                pkgs.tealdeer
                pkgs.tree
                pkgs.docker-client
                pkgs.nerd-fonts.jetbrains-mono

                # Languages
                pkgs.go
            ];
            
            # Used for enabling Touch ID for `sudo`
            # so you don't have to keep entering your password every rebuild.
            security.pam.enableSudoTouchIdAuth = true;
            
            # Apple MacOS Defaults
            # https://daiderd.com/nix-darwin/manual/index.html
            system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
            system.defaults.NSGlobalDomain._HIHideMenuBar = true;
            system.defaults.dock.autohide = true;
            
	    homebrew = {
                enable = true;
                # This option makes the home-brew config declarative.
                # Only packages specified in this file will be installed. 
                # Packages not in the declared list will be removed
                # when you reload with `darwin-rebuild switch`.
                #onActivation.cleanup = "uninstall";
                
                taps = [];
                brews = [
                    #"ack"
                    #"aircrack-ng"
                    #"bash-completion@2"
                    #"bfg"
                    #"binutils"
                    #"binwalk"
                    #"cifer"
                    #"dex2jar"
                    #"dns2tcp"
                    #"fcrackzip"
                    #"findutils"
                    #"foremost"
                    #"ghostscript"
                    #"git"
                    #"git-lfs"
                    #"gnupg"
                    #"grep"
                    #"hydra"
                    #"john"
                    #"knock"
                    #"lynx"
                    #"mas"
                    #"moreutils"
                    #"mysql"
                    #"netpbm"
                    #"nmap"
                    #"node"
                    #"openssh"
                    #"php"
                    #"pigz"
                    #"pngcheck"
                    #"pv"
                    #"pyenv-virtualenv"
                    #"rename"
                    #"rlwrap"
                    #"screen"
                    #"socat"
                    #"sqlmap"
                    #"ssh-copy-id"
                    #"tcpflow"
                    #"tcpreplay"
                    #"tcptrace"
                    #"tealdeer"
                    #"tree"
                    #"ucspi-tcp"
                    #"unar"
                    #"vbindiff"
                    #"woff2"
                    #"xpdf"
                ];
                casks = [
                    "ghostty"
                    "bitwarden"
                    "firefox@developer-edition"
                    #"alfred"
                    #"balenaetcher"
                    #"bbedit"
                    #"caffeine"
                    #"calibre"
                    #"chromium"
                    #"clion"
                    #"datagrip"
                    #"dataspell"
                    #"firefox"
                    #"forklift"
                    #"google-chrome"
                    #"google-drive"
                    #"iterm2"
                    #"libreoffice"
                    #"linearmouse"
                    #"obsidian"
                    #"pycharm"
                    #"rar"
                    #"rectangle"
                    #"the-unarchiver"
                    #"virtualbox"
                    #"visual-studio-code"
                    #"vlc"
                    #"webstorm"
                    #"wireshark"
                    #"zotero"
                ];
                masApps = {
                    "Bear: Markdown Notes" = 1091189122;
                    "BitWarden" = 1352778147;
                    #"Affinity Photo 2: Image Editor" = 1616822987;
                    #"Darkroom: Photo & Video Editor" = 953286746;
                    #"Adobe Lightroom" = 1451544217;
                    #"Paprika Recipe Manager 3" = 3222628;
                };
            };
        };
    in
    {
        darwinConfigurations."mbp2019" = nix-darwin.lib.darwinSystem {
            modules = [
                configuration
                home-manager.darwinModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.nikita = import ./home.nix;
                }
            ];
        };
    };
}
