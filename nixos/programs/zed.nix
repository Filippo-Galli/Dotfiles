{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;

    extensions = [
      "r" # R language support (tree-sitter + languageserver)
      "air" # Air formatter for R (by Posit)
      "clangd" # C++ via clangd LSP
      "python" # Python syntax & tooling
      "nix" # Nix language support
    ];

    userSettings = {
      # ── Panel layout ────────────────────────────────────────────────────────
      panel_overrides = {
        outline_panel = {
          dock = "right";
        };
        collaboration_panel = {
          dock = "right";
        };
        notification_panel = {
          dock = "right";
        };
        # project_panel stays left — file tree and outline on opposite sides
      };

      # ── Keymaps ────────────────────────────────────────────────────────────
      keymap = [
        {
          # Workspace-wide: toggle/take focus of terminal with Alt+Q
          context = "Workspace";
          bindings = {
            "alt-q" = "terminal_panel::ToggleFocus";
          };
        }
      ];

      # ── LSP configuration ──────────────────────────────────────────────────
      lsp = {
        # R: languageserver (install via: install.packages("languageserver"))
        r-language-server = {
          binary = {
            path = "${pkgs.rWrapper}/bin/R";
            arguments = [
              "--no-echo"
              "-e"
              "languageserver::run()"
            ];
          };
        };

        # R: Air formatter LSP (by Posit)
        air = {
          binary.path = "${pkgs.air}/bin/air";
        };

        # C++: clangd
        clangd = {
          binary.path = "${pkgs.clang-tools}/bin/clangd";
          initialization_options = {
            clangdFileStatus = true;
            usePlaceholders = true;
            completeUnimported = true;
          };
        };

        # Nix: nil (understands flakes & devenv.nix)
        nil = {
          binary.path = "${pkgs.nil}/bin/nil";
          settings.nil.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
        };

        # Python: ty — Astral's Rust-based type checker, built into Zed natively
        ty = {
          binary = {
            path = "${pkgs.uv}/bin/uvx";
            arguments = [
              "ty"
              "server"
            ];
          };
        };
      };

      # ── Per-language settings ───────────────────────────────────────────────
      languages = {
        R = {
          tab_size = 4;
          # air must come first — otherwise r_language_server invokes styler
          language_servers = [
            "air"
            "r_language_server"
          ];
          use_on_type_format = false; # let Air own all formatting
          format_on_save = "on";
        };

        C = {
          tab_size = 4;
          formatter = {
            external = {
              command = "${pkgs.clang-tools}/bin/clang-format";
              arguments = [ "--style=file" ];
            };
          };
          format_on_save = "on";
        };

        "C++" = {
          tab_size = 4;
          formatter = {
            external = {
              command = "${pkgs.clang-tools}/bin/clang-format";
              arguments = [ "--style=file" ];
            };
          };
          format_on_save = "on";
        };

        Nix = {
          tab_size = 4;
          formatter = "language_server"; # nixfmt via nil
          format_on_save = "on";
        };

        Python = {
          tab_size = 4;
          # ty is built into Zed; explicitly disable basedpyright/pyright
          language_servers = [
            "ty"
            "!basedpyright"
            "!pyright"
            "..."
          ];
          formatter = {
            external = {
              command = "${pkgs.ruff}/bin/ruff";
              arguments = [
                "format"
                "-"
              ];
            };
          };
          format_on_save = "on";
        };
      };

      # ── General editor preferences ──────────────────────────────────────────
      ui_font_size = 16;
      buffer_font_size = 14;
      autosave = "on_focus_change";
      vim_mode = false;
    };
  };

  # Language tooling available in your shell
  home.packages = with pkgs; [
    # Nix
    nil # Nix LSP
    nixfmt-rfc-style # formatter (RFC 166 style)

    # R
    rWrapper # R runtime (add packages via rWrapper.override)
    air # R formatter by Posit

    # C++
    clang-tools # clangd + clang-format
    cmake
    ninja

    # Python
    uv # runs ty via `uvx ty server`; also replaces pip/venv
    ruff
    python3
  ];
}
