{
  config = {
    extraConfigLua = ''
      -- Fcitx5 用の自動切り替えスクリプト
      local fcitx_cmd = "fcitx5-remote"
      if vim.fn.executable(fcitx_cmd) == 1 then
          local group = vim.api.nvim_create_augroup("FcitxControl", { clear = true })

          -- インサートモードを抜ける時に IME を OFF にし、状態を保存する
          vim.api.nvim_create_autocmd("InsertLeave", {
              group = group,
              callback = function()
                  -- 現在の IME 状態を確認 (1: OFF, 2: ON)
                  local status = vim.fn.system(fcitx_cmd)
                  if tonumber(status) == 2 then
                      vim.g.fcitx_was_on = true
                      vim.fn.system(fcitx_cmd .. " -c") -- IME を閉じる
                  else
                      vim.g.fcitx_was_on = false
                  end
              end,
          })

          -- 再度インサートモードに入った時、直前が ON だったなら ON に戻す
          vim.api.nvim_create_autocmd("InsertEnter", {
              group = group,
              callback = function()
                  if vim.g.fcitx_was_on then
                      vim.fn.system(fcitx_cmd .. " -o") -- IME を開く
                  end
              end,
          })
      end
    '';
  };
}
