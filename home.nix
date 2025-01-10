# ~/.config/nix/home.nix
# Home-Manager configuration file 

{ config, pkgs, ... }:

{
    # Home Manager needs a bit of information about you and the paths it should
    # manage.

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.11"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = [
        # # Adds the 'hello' command to your environment. It prints a friendly
        # # "Hello, world!" when run.
        # pkgs.hello

        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
    };

    # You can also manage environment variables but you will have to manually
    # source
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
    #
    # if you don't want to manage your shell through Home Manager.
    home.sessionVariables = {
        # EDITOR = "emacs";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.zsh = {
        enable = true;
        shellAliases = {
            l = "ls --color=auto";
            ls = "ls --color=auto";
            ll = "ls -l --color=auto";
            lsa = "ls -a --color=auto";
            lla = "ls -la --color=auto";
            ".." = "cd ..";
            c = "clear";
            source-nix = "darwin-rebuild switch --flake ~/.config/nix";
            source-zsh = "source ~/.zshrc";
            source-tmux = "tmux source ~/.config/tmux/tmux.conf";
        };
    };

    programs.tmux = {
        enable = true;
        baseIndex = 1;
        shortcut = "a";
        plugins = with pkgs.tmuxPlugins; [
            {
                plugin = resurrect;
                extraConfig = ''
                    # https://github.com/tmux-plugins/tmux-resurrect
                    set -g @resurrect-strategy-nvim 'session';
                '';
            }
            {
                plugin = power-theme;
                extraConfig = "
                    # https://github.com/wfxr/tmux-power
                    set -g @tmux_power_theme 'gold'
                ";
            }
        ];
        extraConfig = "
            # split panes using \\ and =
            bind = split-window -v
            unbind %

            # Enable mouse control (clickable windows, panes, resizable panes)
            set -g mouse on

            # don't rename windows automatically
            # use in conjunction with , rename hotkey
            set-option -g allow-rename off

            # DESIGN TWEAKS

            # don't do anything when a 'bell' rings
            set -g visual-activity off
            set -g visual-bell off
            set -g visual-silence off
            setw -g monitor-activity off
            set -g bell-action none

            # clock mode
            setw -g clock-mode-colour yellow

            # copy mode
            setw -g mode-style 'fg=black bg=red bold'

            # panes
            set -g pane-border-style 'fg=red'
            set -g pane-active-border-style 'fg=yellow'

            # statusbar
            set -g status-position bottom
            set -g status-justify left
            set -g status-style 'fg=red'

            set -g status-left ''
            set -g status-left-length 10

            set -g status-right-style 'fg=black bg=yellow'
            set -g status-right '%Y-%m-%d %H:%M '
            set -g status-right-length 50

            setw -g window-status-current-style 'fg=black bg=red'
            setw -g window-status-current-format ' #I #W #F '

            setw -g window-status-style 'fg=red bg=black'
            setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '

            setw -g window-status-bell-style 'fg=yellow bg=red bold'

            # messages
            set -g message-style 'fg=yellow bg=red bold'
        ";
        plugins = with pkgs.tmuxPlugins; [{
            plugin = resurrect;
            extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }];
    };
}
