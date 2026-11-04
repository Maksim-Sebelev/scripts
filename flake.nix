{
  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.runCommand "my-scripts" {} ''
            mkdir -p $out/bin
            for script in ${./src/.}/*.sh; do
              install -Dm755 "$script" "$out/bin/$(basename "$script" .sh)"
            done
          '';
        }
      );
    };
}
