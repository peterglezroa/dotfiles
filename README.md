# dotfiles
Dot files for the configuration of multiple tools that I use in different Desktop enviroments

### [Polybar]()

### [Waybar](https://github.com/Alexays/Waybar)

### [Eww](https://github.com/elkowar/eww)

* Fedora dependencies I had to install:
`dnf install cairo-gobject-devel atk-devel gtk3-devel gtk-layer-shell`

(Copy the executable to `.local/bin`)

### Background and colors with [PyWal](https://github.com/dylanaraps/pywal)

#### TODO:
[ ] Terminal theme
[ ] Vim theme
[ ] Rofi
[ ] Firefox
[ ] Discord
[ ] Chrome

[ ] Correct background color

```bash
# Run once
#wal --backend colorthief -i /home/peterglezroa/Pictures/wallpapers -o /home/peterglezroa/bin/openrgb_pywal

# Run every change of wallpaper
cat ~/.cache/wal/sequences


# Add to .bashrc for new terminals to use the colors when openning
(cat ~/.cache/wal/sequences &)
```

If the color variables are needed in the system enviroment add the following line in `~/.bashrc`:
```bash
# .bashrc

# Set enviroment variables
. "~/.cache/wal/colors.sh"
```

*CURRENTLY NOT PYWAL IS NOT WORKING WITH GNOME 42, SET THIS INSTEAD*
```bash
# Run with swaybg
swaybg -i /home/peterglezroa/Pictures/wallpapers/wallpaper_dino.png

# Set terminal colors with wal
wal --backend colorthief -i /home/peterglezroa/Pictures/wallpapers/wallpaper_dino.png
```

### Vim
* PluginInstaller: [vim-plug](https://github.com/junegunn/vim-plug)

### [Waybar](https://github.com/Alexays/Waybar)

### [Powerline](https://powerline.readthedocs.io/en/master/index.html)

[ ] Copy/symbolic link powerline folder to .config folder

```bash
# ~/.bashrc

# Powerline
powerline-daemon -q
. /usr/local/lib/python3.10/site-packages/powerline/bindings/bash/powerline.sh
```

### [Z script](https://github.com/rupa/z)
```bash
# ~/.bashrc

# Z script
. /home/peterglezroa/bin/z.sh
```
