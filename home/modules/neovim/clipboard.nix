{ pkgs, lib, ... }:
{
  config = {
    extraConfigLua = ''
      if os.getenv("SSH_TTY") ~= nil or os.getenv("SSH_CONNECTION") ~= nil then
        vim.g.clipboard = {
          name = 'OSC 52',
          copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
          },
          paste = {
            ["+"] = function() return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') } end,
            ["*"] = function() return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') } end,
          },
        }
      end
    '';
  };
}
