#!/bin/bash
echo "Installing colorz pywal and colorthief with pip3..."
pip3 install colorz pywal colorthief

# sudo apt-get install -y fonts-font-awsome

# Wallpaper directory
[ ! -d "$HOME/Pictures/wallpapers" ] && [ ! -L "$HOME/Pictures/wallpapers" ] && \
    ln -s $PWD/images/wallpapers $HOME/Pictures/wallpapers

# Command
# /home/peterglezroa/.local/bin/wal --backend colorthief -i /home/peterglezroa/Pictures/wallpapers/
# /home/peterglezroa/.local/bin/wal --backend colorthief -i /home/peterglezroa/Pictures/wallpapers/ -o /home/peterglezroa/bin/openrgb_pywal

# Run wal on init
# touch ~/.xsessionrc
#echo 'wal -i "$(< "${HOME}/.cache/wal/wal")" --backend colorthief' >> ~/.xsessionrc

# Wal on bashrc
# echo 'cat ~/.cache/wal/sequences' >> ~/.bashrc
# Hide sidebar
# Appearance -> Behavior -> Auto Hide Launcher

# Fonts (requires sudo)
[ ! -d "/usr/local/share/fonts/VictorMono" ] && [ ! -L "usr/local/share/fonts/VictorMono" ] && \
    mkdir /usr/local/share/fonts/VictorMono && unzip ./fonts/VictorMono.zip -d fonts/ && \
    mv ./fonts/*.ttf /usr/local/share/fonts/VictorMono/

[ ! -d "/usr/local/share/fonts/fontawesome" ] && [ ! -L "usr/local/share/fonts/fontawesome" ] && \
    unzip ./fonts/fontawesome.zip && \
    mv ./fontawesome-free-5.15.4-desktop/ /usr/local/share/fonts/fontawesome/
