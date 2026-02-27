{ ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      wezterm.on('update-status', function(window, pane)
        local domain_name = pane:get_domain_name()
        local overrides = window:get_config_overrides() or {}

        wezterm.log_info("Found domain:", domain_name)
        -- ドメイン名が 'SSHMUX:alice' の場合の設定
        if domain_name == 'SSHMUX:alice' then
          overrides.color_scheme = 'Tokyo Night'
        elseif domain_name == 'SSHMUX:oscar' then
          overrides.color_scheme = 'Mocha (dark) (terminal.sexy)'
        else
          -- それ以外（ローカルなど）はデフォルトに戻す
          overrides.color_scheme = nil
        end

        window:set_config_overrides(overrides)
      end)

      -- 1. .ssh/config からドメイン一覧を取得
      local ssh_domains = wezterm.default_ssh_domains()

      -- 2. 特定のホスト (alice) に対して調整を加える
      for _, dom in ipairs(ssh_domains) do
        local allowed_users = {
          ['SSHMUX:alice'] = true, 
          ['SSHMUX:oscar'] = true
        }
        if allowed_users[dom.name] then
          -- リモートの wezterm パスを明示的に指定（エラー回避の定石）
          -- ※ `which wezterm` で確認したパスに書き換えてください
          dom.remote_wezterm_path = '/run/current-system/sw/bin/wezterm'

          dom.username = dom.remote_address
          
          -- もし接続がすぐに切れる場合は、以下のコメントアウトを外して試してください
          dom.assume_shell = 'Posix'
        end
      end

      config.ssh_domains = ssh_domains

      -- fonts
      config.font = wezterm.font_with_fallback {
        "UbuntuMono Nerd Font Mono",
        "Noto Color Emoji",
        "Noto Sans CJK JP",
      }
      config.font_size = 11
      config.command_palette_font_size = 12

      -- window
      config.window_background_opacity = 1
      config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
      }

      return config
    '';
  };
}
