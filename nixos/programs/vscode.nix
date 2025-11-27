{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode; 

    profiles.default = {
      userSettings = {
        # General editor settings
        "editor.fontFamily" = "'Fira Code'";
        "editor.fontSize" = 14;
        "editor.formatOnSave" = true;
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.cursorBlinking" = "smooth";

        # Password-store management
        "password-store" = "gnome-libsecret";

        # Auto-save settings
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 500; 

        # Nix-specific settings
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "nix.serverPath" = "nil";
          "editor.formatOnSave" = true;
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
        };

        # R-specific settings
        "[r]" = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.formatOnSave" = true;
        };

        # R LSP and integration settings
        "r.rterm.option" = ["--no-save" "--no-restore"];
        "r.sessionWatcher" = true;
        "r.bracketedPaste" = true;
        "r.plot.useHttpgd" = true;

        # Agent mode
        "chat.agent.enabled" = true;
        "github.copilot.enable"= {
          "plaintext"= true;
          "markdown"= true;
        };

        # Theme
        "workbench.activityBar.location" = "bottom";
        "editor.minimap.enabled" = false;
        "window.commandCenter" = false;
        "workbench.sideBar.location" = "right";

        # Terminal settings
        "terminal.integrated.fontFamily" = "'Fira Code'";
        "terminal.integrated.fontSize" = 14;

        # Python settings
        "python.defaultInterpreterPath" = "./.venv/bin/python";

        # Direnv integration
        "direnv.restart.automatic" = true;
        "direnv.status.showOnStatusBar" = true;

	# Disable startup page
	"workbench.startupEditor" = "none";
      };

      # Extensions configuration
      extensions = with pkgs.vscode-extensions; [
        # Essential Nix support
        jnoortheen.nix-ide

        # Copilot and Copilot Chat
        github.copilot
        github.copilot-chat

        # Python linting and formatting with ruff
        charliermarsh.ruff
        ms-python.python
        ms-toolsai.jupyter         # Jupyter support

        # R development
        reditorsupport.r           # Main R extension with console integration
      ];

      keybindings = [
        {
          key = "ctrl+q";
          command = "workbench.action.terminal.toggleTerminal";
        }
      ];
    };
  };
}
