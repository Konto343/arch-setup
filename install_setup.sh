BL='\033[0;34m'
NC='\033[0m'

info () {
	echo -e "\n\n${BL}-------------$1${NC}"
}

yesno () {
	read -p "${1} [y/N] " yesno
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

info "I recommend you enabling 'multilib' in the pacman conf, so you can get all the packages installed correctly."

if yesno "Do you wish to continue with the install?"; then
	info STARTING
else
	exit
fi

info "Pacman Installing base-devel"
sudo pacman -S --needed base-devel git github-cli reflector

if yesno "Do you want update Pacman Mirrors to the fastest available? (Will override current.)"; then
	info "Getting fastest Pacman mirrors"
	sudo reflector --country France,Germany --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --verbose
fi

info "Before Starting, it's Recommended to install AUR helper, such as YAY."
if yesno "Do you want to install the yay package manager?"; then
	sudo rm -r yay
	sudo git clone https://aur.archlinux.org/yay.git
	sudo chown -R 1000:1000 yay
 	cd yay
	makepkg -si
	yay --version
fi

if yesno "Do you want to install the base setup?"; then
	info "Installing Ly (Greeter)"
	sudo pacman -S ly
	sudo systemctl enable ly

	info "Installing Hyprland"
	sudo pacman -S hypridle hyprland hyprlock hyprpaper hyprpicker xdg-desktop-portal-hyprland
	sudo pacman -S xdg-desktop-portal-hyprland qt5-wayland qt6-wayland polkit-kde-agent kitty grim slurp thunar nwg-look nwg-bar blueman brightnessctl mako pavucontrol playerctl waybar wl-clipboard rofi ttf-jetbrains-mono-nerd power-profiles-daemon wlsunset
	yay -S waypaper

	info "Installing Must needs"
	sudo pacman -S 7zip blueman btop fzf powertop dust cmus cups cups-filters cups-pdf fish flatpak git jre21-openjdk kitty nano ncdu fastfetch neovim npm pyenv tmux ufw unzip zip tar tumbler ffmpeg ffmpegthumbnailer lshw nano-syntax-highlighting tealdeer rsync powertop speedtest-cli
	yay -S betterbird-bin

	info "Installing Dev Software"
	sudo pacman -S zed
	yay -S vscodium-bin

	info "Installing Broswer"
	yay -S waterfox-bin

	info "Installing Extras"
	sudo pacman -S blender gimp qalculate-gtk orage gnome-clocks gnome-disk-utility gnome-maps cherrytree hexchat inkscape geeqie libreoffice-fresh mpv mupdf obs-studio obsidian openshot gnome-theme-extras

	info "Installing Security Extras"
	sudo pacman -S keepassxc tor signal-desktop element-desktop syncthing wireshark-cli
	yay -S mullvad-vpn-bin

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

if yesno "Do you Own a Brother Laser-Printer and want to install the driver?"; then
	yay -S brlaser
fi

if yesno "Do you want to install extra yay packages?"; then
	yay -S vesktop-bin cbonsai pipes.sh cava localsend-bin
fi

info "SETUP COMPLETE"
