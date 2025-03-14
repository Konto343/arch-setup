function fish_prompt
	string join '' -- \n (set_color yellow) (date +'%H:%M:%S %p') ' ' (set_color $fish_color_cwd) (whoami) (set_color normal) '@' (set_color cyan) (prompt_hostname) ' ' (set_color cyan) (prompt_pwd) (set_color normal) ' > '
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Remove annoying welcome message
set fish_greeting

# Alias
alias ls='ls -la'
alias reload_waybar="pkill waybar && hyprctl dispatch exec waybar"

function weather
    curl "https://wttr.in/$argv[1]"
end
