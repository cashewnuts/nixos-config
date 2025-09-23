{ ... }:
{
  home.file = {
    ".config/kitty/ssh.conf" = {
      source = ./kitty/ssh.conf;
    };
  };
}
