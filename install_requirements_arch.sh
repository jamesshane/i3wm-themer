#!/bin/env sh

### Script written by Stavros Grigoriou ( github.com/unix121 )
### 20180505 Changes fully commented by James Shane ( github.com/jamesshane )


#added binutils,gcc,make,pkg-config,fakeroot for compilations, removed yaourt
sudo pacman -S git nitrogen rofi python-pip ttf-font-awesome adobe-source-code-pro-fonts binutils gcc make pkg-config fakeroot --noconfirm

#added PYTHONDONTWRITEBYTECODE to prevent __pycache__
export PYTHONDONTWRITEBYTECODE=1
sudo pip install -r requirements.txt

#install yaourt by source
git clone https://aur.archlinux.org/package-query.git
cd package-query
makepkg -si --noconfirm
cd ..
rm -fr package-query
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
makepkg -si --noconfirm
cd ..
rm -fr yaourt
mkdir $HOME/tmpyaourt
#went with nerd-fonts-git, other is outta date
yaourt -S polybar-git ttf-nerd-fonts-symbols --noconfirm --tmp $HOME/tmpyaourt
rmdir $HOME/tmpyaourt

#directory may not be needed, but it makes a cleaner install, went with nerd-fonts-git, other is outta date
#sudo mkdir /usr/share/fonts/OTF
#git clone https://aur.archlinux.org/ttf-nerd-fonts-symbols.git 
#cd ttf-nerd-fonts-symbols
#makepkg -si --noconfirm
#cd ..
#rm -fr ttf-nerd-fonts-symbols

#install -Dm644 /usr/share/doc/polybar/config $HOME/.config/polybar/config

#file didn't exist for me, so test and touch
if [ -e $HOME/.Xresources ]
then
	echo "... .Xresources found."
else
	touch $HOME/.Xresources
fi

#rework of user in config.yaml
cd src
rm -f config.yaml
cp defaults/config.yaml .
sed -i -e "s/USER/$USER/g" config.yaml

#file didn't excist for me, so test and touch
if [ -e $HOME/.config/polybar/config ]
then
        echo "... polybar/config found."
else
	mkdir $HOME/.config/polybar
        touch $HOME/.config/polybar/config
fi

#backup, configure and set theme to 000
cp -r ../scripts/* /home/$USER/.config/polybar/
mkdir $HOME/Backup
python i3wm-themer.py --config config.yaml --backup $HOME/Backup
python i3wm-themer.py --config config.yaml --install defaults/


