{
  config,
  pkgs,
  lib,
  ...
}:
{
  plugins = {
    lsp-lines = {
      enable = true;
    };
    lsp-format = {
      enable = true;
    };
    helm = {
      enable = true;
    };
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        superhtml = {
          enable = true;
        };
        sqls = {
          enable = true;
        };
        lua_ls = {
          enable = true;
        };
        nil_ls = {
          enable = true;
          settings = {
            nix = {
              flake = {
                autoArchive = true;
              };
            };
          };
        };
        ts_ls = {
          enable = true;
          autostart = true;
        };
        marksman = {
          enable = true;
        };
        terraformls = {
          enable = true;
        };
        jsonls = {
          enable = true;
        };
        yamlls = {
          enable = true;
          extraOptions = {
            settings = {
              yaml = {
                schemas = {
                  kubernetes = "'*.yaml";
                  "http://json.schemastore.org/github-workflow" = ".github/workflows/*";
                  "http://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                  "http://json.schemastore.org/ansible-stable-2.9" = "roles/tasks/*.{yml,yaml}";
                  "http://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
                  "http://json.schemastore.org/ansible-playbook" = "*play*.{yml,yaml}";
                  "http://json.schemastore.org/chart" = "Chart.{yml,yaml}";
                  "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
                  "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
                    "*docker-compose*.{yml,yaml}";
                  "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json" =
                    "*flow*.{yml,yaml}";
                };
              };
            };
          };
        };
        rust_analyzer = {
          enable = true;
          autostart = true;
          installCargo = false;
          installRustc = false;
        };
      };

      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>rn" = {
            action = "rename";
            desc = "Rename";
          };
        };
        diagnostic = {
          "<leader>cd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
        extra = [
          {
            key = "<leader>li";
            action = "<CMD>LspInfo<Enter>";
          }
          {
            key = "<leader>lr";
            action = "<CMD>LspRestart<Enter>";
          }
          {
            mode = "n";
            key = "gd";
            action.__raw = ''
              function() 
                require('telescope.builtin').lsp_definitions({ reuse_win = true })
              end
            '';
          }
          {
            mode = "n";
            key = "gr";
            action.__raw = ''
              function()
                require('telescope.builtin').lsp_references({ reuse_win = true })
              end
            '';
          }
          {
            mode = "n";
            key = "gI";
            action.__raw = ''
              function()
                require('telescope.builtin').lsp_implementations({ reuse_win = true })
              end
            '';
          }
          {
            mode = "n";
            key = "gT";
            action.__raw = ''
              function()
                require('telescope.builtin').lsp_type_definitions({ reuse_win = true })
              end
            '';
          }
        ];
      };
    };
  };
}
