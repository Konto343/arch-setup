# Dynamic Wallpaper Loading

source_dir=~/.config/hypr/wallpapers
target="${source_dir}/${1}"

if [ -f $target ]; then
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $target
    hyprctl hyprpaper wallpaper ", $target"
    notify-send "Changed Wallpaper to: $target"
fi
