{ system, pkgs, nixvim, ... }:
let
  neovimconfig = import ./neovim;
  nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    module = neovimconfig;
    extraSpecialArgs = {
      defaultEditor = true;
      vimdiffAlias = true;
      wrapRc = false;
    };
  };
in {
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.packages = [
    nvim
  ];
}

