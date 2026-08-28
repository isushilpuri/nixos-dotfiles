{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    # # Dotfiles flake
    # nix-dots.url = "path:/home/v0idshil/nix-dots"; # Change path if needed
    omp.url = "github:can1357/oh-my-pi";
    
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, nvf, ... }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
    in
    {
      packages.${system}.neovim =
	      (nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            ./nvf/nvf_conf.nix
          ];
	      })
	      .neovim;

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ 
            ./configuration.nix
            # nvf
            ({pkgs, ...}: {
              environment.systemPackages = [self.packages.${pkgs.stdenv.system}.neovim];
            })
            # home-manager
            home-manager.nixosModules.home-manager
            {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                        # To use 'self' inside home.nix
                              extraSpecialArgs = { inherit self inputs; };
                  users.v0idshil = import ./home.nix;
                  backupFileExtension = "backup";
                };
            }
            # noctalia for niri
            # ./noctalia.nix
          ];
      };
    };
}
