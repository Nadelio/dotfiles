# config.nu
#
# Installed by:
# version = "0.104.1"
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

$env.config.buffer_editor = "usr/bin/nvim/nvim.exe"
$env.config.show_banner = false
$env.config.color_config.background = "none"

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

alias root = cd ~

def sum [a, b] {
    $a + $b
}

def restart [] {
    start "usr/bin/wezterm/wezterm-gui.exe"
    exit
}

def rebuild [] {
    cargo clean
    cargo build -r
    cls
    echo $"(ansi green)Rust Project Rebuild Successful(ansi reset)"
}

def config [app] {
    if $app == "nvim" {
        cd "~/.config/nvim"
        nvim init.lua
    } else if $app == "wezterm" {
        cd "~/.config/wezterm"
        nvim wezterm.lua
    } else if $app == "nu" {
        cd "~/.config/nushell"
        nvim config.nu
    } else if $app == "starship" {
        cd "~/.config"
        nvim starship.toml
    } else {
        echo $"(ansi red)Unknown config. Please retry(ansi reset)"
    }
}

alias lua = lua54
alias refresh = restart
alias reboot = restart
