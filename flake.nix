{
  description = "mcmania PaperMC plugin and local server bundle";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          pluginJar = pkgs.stdenvNoCC.mkDerivation {
            pname = "mcmania-plugin";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = [ pkgs.gradle pkgs.temurin-bin-17 ];

            buildPhase = ''
              runHook preBuild
              export GRADLE_USER_HOME="$TMPDIR/gradle-home"
              gradle --no-daemon :lib:jar
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              mkdir -p "$out"
              cp lib/build/libs/mcmania-plugin-0.1.0.jar "$out/mcmania-plugin.jar"
              runHook postInstall
            '';
          };

          serverBundle = pkgs.runCommand "mcmania-server-bundle" { } ''
            mkdir -p "$out/plugins"
            cp ${pluginJar}/mcmania-plugin.jar "$out/plugins/mcmania-plugin.jar"
            ln -s ${pkgs.lib.getExe pkgs.papermc} "$out/minecraft-server"
            cat > "$out/eula.txt" <<'EULA'
eula=true
            EULA
            cat > "$out/server.properties" <<'PROPS'
motd=mcmania
enable-command-block=false
max-players=20
online-mode=false
allow-flight=true
            PROPS
            cat > "$out/start-server" <<'SCRIPT'
#!${pkgs.runtimeShell}
set -euo pipefail
bundle_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$bundle_dir"
exec "$bundle_dir/minecraft-server"
            SCRIPT
            chmod +x "$out/start-server"
          '';
        in
        {
          plugin-jar = pluginJar;
          server-bundle = serverBundle;
          default = serverBundle;
        });

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.temurin-bin-17
              pkgs.gradle
              pkgs.papermc
            ];
          };
        });
    };
}
