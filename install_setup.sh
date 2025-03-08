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

info "Pacman Installing base-devel"
sudo pacman -S --needed base-devel git github-cli reflector

if yesno "Do you want update Pacman Mirrors to the fastest available? (Will override current.)"; then
	info "Getting fastest Pacman mirrors"
	sudo reflector --country France,Germany --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --verbose
fi

if yesno "Do you want to install the base setup?"; then
	info "Installing Ly (Greeter)"
	sudo pacman -S ly
	sudo systemctl enable ly

	info "Installing Hyprland"
	sudo pacman -S hypridle hyprland hyprlock hyprpaper hyprpicker xdg-desktop-portal-hyprland
	sudo pacman -S xdg-desktop-portal-hyprland qt5-wayland qt6-wayland polkit-kde-agent kitty grim slurp thunar nwg-look nwg-bar blueman brightnessctl mako pavucontrol playerctl waybar wl-clipboard rofi ttf-jetbrains-mono-nerd power-profiles-daemon

	info "Installing Must needs"
	sudo pacman -S 7zip blueman btop fzf powertop dust cmus cups fish flatpak geeqie gimp git qalculate-gtk orage gnome-clocks gnome-disk-utility gnome-maps cherrytree hexchat inkscape jre21-openjdk keepassxc kitty libreoffice-fresh mpv mupdf nano ncdu fastfetch neovim npm obs-studio obsidian openshot pyenv signal-desktop tmux tor ufw unzip zip tar tumbler ffmpeg ffmpegthumbnailer lshw nano-syntax-highlighting tealdeer rsync powertop speedtest-cli blender

	info "Adding Syntax Highlighting For Nano (System)"
	echo "include /usr/share/nano-syntax-highlighting/*.nanorc" | sudo tee -a /etc/nanorc

	info "File System support(s)"
	sudo pacman -S gvfs gvfs-gphoto2 gvfs-mtp mtpfs ntfs-3g
fi

if yesno "Do you have a Nvidia GPU?"; then
	sudo pacman -S nvidia nvidia-utils nvidia-container-toolkit opencl-nvidia # lib32-nvidia-utils
fi

if yesno "Do you intend to use Docker?"; then
	sudo pacman -S docker docker-compose
fi

if yesno "Do you want to install the yay package manager?"; then
	sudo rm -r yay
	sudo git clone https://aur.archlinux.org/yay.git
	sudo chown -R 1000:1000 yay
 	cd yay
	makepkg -si
	yay --version
fi

if yesno "Do you want to install extra yay packages?"; then
	yay -S vesktop-bin vscodium-bin betterbird-bin librewolf-bin cbonsai pipes.sh cava waypaper localsend-bin
fi

info "SETUP COMPLETE"
