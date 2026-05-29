# mcmania

Minecraft paper plugin that denies block breaking.

## Plugin behavior

Any block break attempt is cancelled and the player receives:

```text
nope!
```

## Build (Gradle)

```bash
./gradlew :lib:jar
```

## Nix

- `nix build .#plugin-jar` builds only the plugin jar.
- `nix build` (same as `nix build .#server-bundle`) builds a server bundle with:
  - Paper server binary
  - plugin jar in `plugins/`
  - `server.properties`
  - `eula.txt`
  - `start-server` launcher script
- `nix develop` provides a shell with Java, Gradle, and Paper server (`minecraft-server`) in `PATH`.
