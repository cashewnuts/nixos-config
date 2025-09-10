{ pkgs, lib, ... }:
{
  config.keymaps = [
    # Buffer
    {
      key = "bd";
      action = "<cmd>bd<CR>";
      mode = "n";
      options.desc = "Delete Buffer";
    }
    {
      key = "bn";
      action = "<cmd>bn<CR>";
      mode = "n";
      options.desc = "Next Buffer";
    }
    {
      key = "bp";
      action = "<cmd>bp<CR>";
      mode = "n";
      options.desc = "Previous Buffer";
    }
    # Window
    {
      key = "wd";
      action = "<cmd>close<CR>";
      mode = "n";
      options.desc = "Close Window";
    }
    {
      key = "<C-h>";
      action = "<C-w>h";
      mode = "n";
      options.desc = "Focus Left Window";
    }
    {
      key = "<C-j>";
      action = "<C-w>j";
      mode = "n";
      options.desc = "Focus Down Window";
    }
    {
      key = "<C-k>";
      action = "<C-w>k";
      mode = "n";
      options.desc = "Focus Up Window";
    }
    {
      key = "<C-l>";
      action = "<C-w>l";
      mode = "n";
      options.desc = "Focus Right Window";
    }
  ];
}
