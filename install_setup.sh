BL='\033[0;34m'
NC='\033[0m'

info () {
	echo -e "${BL}-------------$1${NC}\n\n\n"
}

yesno () {
	read -p "${1} [Y/N] " yesno
    	case $yesno in
        	[Yy]* ) 
            		return 0;
        	;;

        	[Nn]* ) 
			return 1;
            	exit
        	;;

		* ) return 1;
	esac
}

if yesno "Do you wish to continue with the install?"; then
	info EXIT
else
	exit
fi

info "Updating Pacman and Installing base-devel"
sudo pacman -Syu
yes | sudo pacman -S --needed base-devel git github-cli reflector

if yesno "Do you want update Pacman Mirrors to the fastest available? (Will override current.)"; then
	info "Getting fastest Pacman mirrors"
	sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
fi

if yesno "Do you want to install the base setup?"; then
	info "Installing Ly (Greeter)"
	yes | sudo pacman -S ly
	yes | sudo systemctl enable ly

	info "Installing Hyprland"
	yes | sudo pacman -S hypridle hyprland hyprlock hyprpaper hyprpicker xdg-desktop-portal-hyprland
	yes | sudo pacman -S xdg-desktop-portal-hyprland xorg-xhost qt5-wayland qt6-wayland polkit-kde-agent kitty grim slurp thunar nwg-look nwg-bar blueman brightnessctl mako pavucontrol playerctl waybar wl-clipboard wofi rofi ttf-jetbrains-mono-nerd power-profiles-daemon

	info "Installing Must needs"
	yes | sudo pacman -S 7zip blueman btop fzf powertop dust cmus cups fish flatpak geeqie gimp git qalculate-gtk orage gnome-clocks gnome-disk-utility gnome-maps cherrytree hexchat inkscape jre21-openjdk keepassxc kitty libreoffice-still mpv mupdf nano ncdu fastfetch neovim npm obs-studio obsidian openshot pyenv signal-desktop tmux tor ufw unzip tar tumbler ffmpeg ffmpegthumbnailer lshw nano-syntax-highlighting tealdeer rsync powertop speedtest-cli

	info "File System support(s)"
	yes | sudo pacman -S gvfs gvfs-gphoto2 gvfs-mtp mtpfs ntfs-3g
fi

if yesno "Do you have a Nvidia GPU?"; then
	yes | sudo pacman -S nvidia nvidia-utils nvidia-container-toolkit opencl-nvidia
fi

if yesno "Do you intend to use Docker?"; then
	yes | sudo pacman -S docker docker-compose
fi

if yesno "Do you want to install the yay package manager?"; then
	sudo rm -r yay
	sudo git clone https://aur.archlinux.org/yay.git
	sudo chown 1000:1000 ~/yay/
	cd yay
	makepkg -si
	yay --version
fi

if yesno "Do you want to install extra yay packages?"; then
	yay -S vesktop-bin vscodium-bin betterbird-bin librewolf-bin cbonsai pipes.sh cava octopi waypaper localsend-bin
fi

if yesno "Do you want to cleanup packages?"; then
	sudo pacman -Scc && yay -Scc && pacman -Qtdq | sudo pacman -Rns -
fi

info "SETUP COMPLETE"
