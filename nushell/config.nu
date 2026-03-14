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

use std/config dark-theme

$env.config.buffer_editor = "C:\\Program Files\\Neovim\\bin\\nvim.exe"
$env.config.show_banner = false
$env.config.color_config = (dark-theme)
$env.config.color_config.background = "none"

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

alias root = cd ~

def sum [a, b] {
    $a + $b
}

def restart [] {
    start "C:\\Program Files\\WezTerm\\wezterm-gui.exe"
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
        cd "~\\AppData\\Local\\nvim"
        nvim init.lua
    } else if $app == "wezterm" {
        cd "~\\.config\\wezterm"
        nvim wezterm.lua
    } else if $app == "nu" {
        cd "~\\AppData\\Roaming\\nushell"
        nvim config.nu
    } else if $app == "starship" {
        cd "~\\.config"
        nvim starship.toml
    } else {
        echo $"(ansi red)Unknown config. Please retry(ansi reset)"
    }
}

def "into ascii" [] {
    split words
    | into int --radix 2
    | each { |element| char --integer ($element) }
    | str join
}

def "new note" [filename: string] {
	let date_str = (date now | format date "%m/%d/%Y (%B)")
	$"# ($filename | str substring 0..-4)\n\nDate: ($date_str)\n\n## Notes:" | save $filename
}

def "date to int" [date: string] {
	let hours = $date | str substring 0..1 | into int
	let minutes = $date | str substring 3.. | into int

	echo (($hours * 60) + $minutes)
}

def "int to date" [number: int] {
	let hours = $number // 60
	let minutes = $number mod 60
	echo $hours ":" $minutes
}

alias "jump nvim" = cd "~\\AppData\\Local\\nvim"
alias "jump nu" = cd "~\\AppData\\Roaming\\nushell"
alias "jump wezterm" = cd "~\\.config\\wezterm"
alias "jump starship" = cd "~\\.config"
alias lua = lua54
alias refresh = restart
alias reboot = restart
alias stat = git status
alias add = git add .
alias commit = git commit -m
alias push = git push
alias remote = git remote add
alias read = nvim -mR
alias irc = wsl weechat
alias "update music" = yt-dlp -t mp3 https://youtube.com/playlist?list=PL1oC33eHpJzXCysG1HtQOkBVc2jlaRwz_ --sleep-subtitles 5 --sleep-requests 10 --sleep-interval 10 --max-sleep-interval 20 --download-archive "F:/Youtube Music/meta.txt" --force-download-archive -k --cookies-from-browser FIREFOX --remote-components ejs:npm
alias "download wav" = yt-dlp -f bestaudio -x --audio-format wav https://youtube.com/playlist?list=PL1oC33eHpJzXCysG1HtQOkBVc2jlaRwz_ --sleep-subtitles 5 --sleep-requests 10 --sleep-interval 10 --max-sleep-interval 20 --download-archive "F:/Youtube Music/meta_wav.txt" --force-download-archive -k --cookies-from-browser FIREFOX --remote-components ejs:npm
