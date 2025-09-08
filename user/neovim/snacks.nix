{ pkgs, lib, ... }:
{
  config = {
    plugins = {
      snacks = {
        enable = true;
        autoLoad = true;
      };
    };
    keymaps = [
      # Picker
      {
        key = "<leader><space>";
        mode = [ "n" ];
        action = "<cmd>lua Snacks.picker.smart()<CR>";
        options = {
          desc = "Smart Find Files";
        };
      }
      {
        key = "<leader>e";
        mode = [ "n" ];
        action = "<cmd>lua Snacks.explorer()<CR>";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        key = "<leader>fb";
        mode = [ "n" ];
        action = "<cmd>lua Snacks.picker.buffers()<CR>";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        key = "<leader>ff";
        mode = [ "n" ];
        action = "<cmd>lua Snacks.picker.files()<CR>";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        key = "<leader>gl";
        mode = [ "n" ];
        action = "<cmd>lua Snacks.picker.git_log()<CR>";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        key = "<leader>gs";
        mode = [ "n" ];
        action = "<cmd>lua Snacks.picker.git_status()<CR>";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        key = "<leader>uC";
        mode = [ "n" ];
        action = "<cmd>lua Snacks.picker.colorschemes()<CR>";
      }
      {
        key = "<leader>:";
        mode = [ "n" ];
        action = "<cmd>lua Snacks.picker.command_history()<CR>";
      }
      # Terminal
      {
        key = "<C-/>";
        mode = [ "n" "t" ];
        action = "<cmd>lua Snacks.terminal()<CR>";
        options.desc = "Toggle Terminal";
      }
    ];
  };
}
