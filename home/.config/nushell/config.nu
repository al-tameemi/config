# config.nu
#
# Installed by:
# version = "0.102.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.
use std/config *

$env.config.hooks.command_not_found = {
  |command_name|
  print (command-not-found $command_name | str trim)
}

$env.config.buffer_editor = "hx"

# Initialize the PWD hook as an empty list if it doesn't exist
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

devenv hook nu | save --force ~/.config/nushell/devenv_hook.nu
source ~/.config/nushell/devenv_hook.nu

# $env.config.hooks.env_change.PWD ++= [{||
#   if (which direnv | is-empty) {
#     # If direnv isn't installed, do nothing
#     return
#   }

#   direnv export json | from json | default {} | load-env
#   # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
#   $env.PATH = do (env-conversions).path.from_string $env.PATH
# }]

alias watts = print $"((cat /sys/class/power_supply/BAT1/current_now | into int ) * (cat /sys/class/power_supply/BAT1/voltage_now | into int) / 1e12 | into string --decimals 2)W";

def sconf [pattern: string] {
  rg $pattern /config/*/*.nix
}

def ll [
    ...args
    --all (-a)
    --du (-d)
    --full-paths (-f)
    --mime-type (-m)
    --short-names (-s)
    --threads (-t)
] {
  if ($args | is-empty) {
    ls -l --all=$all --du=$du --full-paths=$full_paths --mime-type=$mime_type --short-names=$short_names --threads=$threads
  } else {
    ls -l ...$args --all=$all --du=$du --full-paths=$full_paths --mime-type=$mime_type --short-names=$short_names --threads=$threads
  }
}
