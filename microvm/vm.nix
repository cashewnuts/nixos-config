{
  nixpkgs,
  username,
  impermanence,
  index,
  vm,
  ...
}:
{
  microvm.vms.${username} = {
    # The package set to use for the microvm. This also determines the microvm's architecture.
    # Defaults to the host system's package set if not given.
    pkgs = import nixpkgs { system = "x86_64-linux"; };

    autostart = false;

    # (Optional) A set of special arguments to be passed to the MicroVM's NixOS modules.
    specialArgs = {
      inherit impermanence;
      inherit username;
      inherit index;
    };

    # The configuration for the MicroVM.
    # Multiple definitions will be merged as expected.
    config = {
      imports = [
        ./vms/${vm}.nix
      ];
    };
  };
}
