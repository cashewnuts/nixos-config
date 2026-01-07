{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.my.ssh.enable {
    programs.ssh = {
      setXAuthLocation = true;
    };
  };
}
