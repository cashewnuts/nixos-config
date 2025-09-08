{
  plugins.bufferline = {
    enable = true;
    autoLoad = true;
    settings = {
      options = {
        close_command = "lua Snacks.bufdelete(%d)";
        right_mouse_command = "lua Snacks.bufdelete(%d)";
        always_show_bufferline = false;
      };
    };
  };
}

