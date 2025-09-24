{ ... }:
{
  home.file = {
    ".config/kitty/kitty.conf" = {
      source = ./kitty/kitty.conf;
    };
    ".config/kitty/ssh.conf" = {
      source = ./kitty/ssh.conf;
    };
  };
}
