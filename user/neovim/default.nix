{ pkgs, lib, ... }:
{
  imports = [
    ./snacks.nix
    ./web-devicons.nix
  ];

  config = {
    globals = {
      mapleader = "\\"; # Sets the leader
      maplocalleader = "\\";
    };
    opts = {
      # Line numbers
      number = true;
      relativenumber = true;
      
      # Indentation
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      
      # Search behavior
      ignorecase = true;
      smartcase = true;
      hlsearch = false;

      # Visual settings
      wrap = false;
      cursorline = true;
      signcolumn = "yes";
    };
    globalOpts = {
      # Mouse support
      mouse = "a";
      
      # Clipboard integration
      clipboard = "unnamedplus";
      
      # Update timing
      updatetime = 250;
    };
    localOpts = {
      # Concealment level for current buffer
      conceallevel = 0;
    };
    keymaps = [
      # {
      #   key = "<leader>e";
      #   action = "<Cmd>Neotree<CR>";
      #   mode = "n";
      #   options.desc = "Open Neotree";
      # }
      # {
      #   key = "<C-h>";
      #   action = "<C-w>h";
      #   mode = "n";
      #   options.desc = "Focus Left Window";
      # }
      # {
      #   key = "<C-j>";
      #   action = "<C-w>j";
      #   mode = "n";
      #   options.desc = "Focus Down Window";
      # }
      # {
      #   key = "<C-k>";
      #   action = "<C-w>k";
      #   mode = "n";
      #   options.desc = "Focus Up Window";
      # }
      # {
      #   key = "<C-l>";
      #   action = "<C-w>l";
      #   mode = "n";
      #   options.desc = "Focus Right Window";
      # }
    ];
    colorschemes.tokyonight = {  
      # https://github.com/folke/tokyonight.nvim
      enable = true;  
      settings = {  
        style = "moon"; 
        light_style = "day";  
      };  
    };
    plugins = {
      lsp = {
        enable = true;
        keymaps = {  
          silent = true;  
          diagnostic = {  
            "<leader>k" = "goto_prev";  
            "<leader>j" = "goto_next";  
          };  
          lspBuf = {  
            "gd" = "definition";  
            "gD" = "references";  
            "gt" = "type_definition";  
            "gi" = "implementation";  
            "K" = "hover";  
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
          ];  
        };
        servers = {
          bashls.enable = true;
          nil_ls.enable = true;
        };
      };
    };
  };
}
