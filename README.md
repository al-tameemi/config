# NixOS config

One flake, three hosts, shared modules.

| Host | Output | nixpkgs | Role |
|------|--------|---------|------|
| `nixos` | `nixosConfigurations.nixos` | `nixpkgs` (nixos-unstable) | Desktop (AMD, lanzaboote secure boot, niri) |
| `framework` | `nixosConfigurations.framework` | `nixpkgs` (nixos-unstable) | Framework 13 laptop |
| `minipc` | `nixosConfigurations.minipc` | `nixpkgs-server` (nixos-26.05) | Headless server, reachable as `minipc.local` (Home Assistant, Valheim, Minecraft, resolver) |

Build/deploy:

```sh
sudo nixos-rebuild switch --flake /config#nixos        # or #framework
nixos-rebuild switch --flake .#minipc --target-host mohammed@minipc.local --sudo --ask-sudo-password
```

`minipc.local` works because the server publishes its hostname over mDNS (avahi), so no IP is needed. The sudo password is asked on every deploy (passwordless sudo is deliberately not enabled).

**Bootstrapping a new server:** the first deploy to a machine still running a stock install fails with `lacks a signature by a trusted key`, because the target's nix daemon doesn't yet trust your user. Add `nix.settings.trusted-users = [ "root" "<user>" ];` to its `/etc/nixos` config and `nixos-rebuild switch` once on the box. After that the flake config sets it (via `common/nix.nix`). Until the new host publishes `<name>.local`, deploy to its IP.

## Layout

```
flake.nix            inputs + the three nixosConfigurations
flake.lock
configuration.nix    shared desktop base, imported by nixos and framework (NOT minipc)
common/              reusable modules, each gated by a modules.* option
common/server/       headless-server modules (modules.server.*)
nixos/               desktop-only: configuration, hardware-configuration, extra mounts
framework/           laptop-only: configuration, hardware, suspend/hibernate
minipc/              server host data (hardware + which server modules to enable)
home/.config/        dotfiles, bind-mounted onto ~/.config
```

### `flake.nix`

- `nixpkgs` is unstable and used by `nixos` and `framework`. `lanzaboote` and `flake-programs-sqlite` follow it.
- `nixpkgs-server` is a separate pin used by all server hosts (via `mkServer`). Update it with `nix flake update nixpkgs-server`; move to a new release by editing its URL.
- Each host is a list of modules. Per-host files are listed there; shared ones come from `./configuration.nix`.

### `configuration.nix` (root)

Shared base for the desktop-class hosts: nix settings, networking, locale, shells, and it imports everything in `common/` and turns on the base `modules.*` options. Per-host files then set `modules.username`, `modules.desktop.enable`, and so on.

### `common/`

Modules that declare `options.modules.<name>` and wrap their config in `lib.mkIf`, so importing one is harmless until a host enables it.

- `boot.nix`, `services.nix`, `desktop-services.nix`, `desktop.nix`, `virt.nix`, `mounts.nix`, `programs-sqlite.nix`
- `packages/`: package sets split by theme (`browsers`, `media`, `gaming`, `dev/`, `cli/`, `desktop/` for gnome/niri/hyprland, `system/`). `packages/default.nix` imports all of them; `profiles/` bundles them (`general`, `desktop`).
- `packages/options.nix` defines `modules.username`, which every host must set.

### `nixos/`, `framework/`

Host-specific settings: hardware config, filesystems, kernel params, and which `modules.*` options to enable.

### `common/server/`

Headless-server modules, imported by `mkServer` in `flake.nix` (never by the desktops). Everything is under `modules.server.*`:

- `base.nix` (`enable`, `timeZone` default America/Denver): systemd-boot, zen kernel, NetworkManager, no sleep, openssh, avahi publishing `<hostname>.local`, the primary user.
- `home-assistant.nix`: port, `unitSystem`, `extraComponents`. Time zone comes from `timeZone`.
- `minecraft.nix`: port, memory, motd, `whitelist`, `extraProperties`.
- `valheim.nix`: docker plus firewall ports. The container runs from `~/valheim-server/docker-compose.yaml` on the host.
- `reverse-proxy.nix`: `hosts.<domain>.port` generates nginx vhosts (TLS using `certDir`/cert.pem+key.pem) and opens 80/443.
- `resolver.nix`: runs `<dir>/resolver_server`; set `domain` to expose it through the reverse proxy.

Shared with the desktops: `common/locale.nix`, `common/nix.nix`, and the `modules.username` option.

### `minipc/`

Only host-specific data: `hardware-configuration.nix` (generated; redo with `nixos-generate-config`) and `configuration.nix`, which sets the username, enables the server modules and gives the whitelist and domain.

**Adding a server:** create `<name>/configuration.nix` and `<name>/hardware-configuration.nix`, then add `nixosConfigurations.<name> = mkServer "<name>" [ ];`. The hostname comes from the attribute name; no IPs are configured anywhere (DHCP + mDNS).

### `home/.config/`

`common/mounts.nix` bind-mounts this directory over `~/.config`, so edits are live with no rebuild. `.gitignore` ignores everything in it except an explicit allowlist (alacritty, niri, waybar, nushell, ...). Add a `!home/.config/<app>` line to track a new app.

## Conventions

- Shared behaviour goes in `common/` behind an option; host-specific values go in the host directory.
- Modules should take `pkgs` from their arguments rather than `inputs.nixpkgs`, so they use the nixpkgs of whichever host imports them.
- New files must be `git add`ed before building, because flakes ignore untracked files.
- Anything imported by a server is evaluated against nixpkgs 26.05, so it must not rely on options that only exist in unstable.
