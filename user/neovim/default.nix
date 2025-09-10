{ pkgs, lib, ... }:
{
  imports = [
    ./blink-cmp.nix
    ./bufferline.nix
    ./colorschemes.nix
    ./keymaps.nix
    ./lualine.nix
    ./snacks.nix
    ./treesitter.nix
    ./web-devicons.nix
    ./whichkey.nix
    ./lsp/lsp.nix
    ./lsp/confirm.nix
    ./lsp/fidget.nix
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
      tabstop = 2;
      shiftwidth = 2;
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
  };
}
