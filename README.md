# dotfiles
Dot files for the configuration of multiple tools that I use in different Desktop enviroments

### [Alacritty]()
[ ] `$DOTFILES/alacritty.yml` -> `~/.config/alacritty/alacritty.yml`

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
### [Polybar]()

### [Waybar](https://github.com/Alexays/Waybar)

### [Eww](https://github.com/elkowar/eww)

* Fedora dependencies I had to install:
`dnf install cairo-gobject-devel atk-devel gtk3-devel gtk-layer-shell`

(Copy the executable to `.local/bin`)

### NeoVim

[ ] `$DOTFILES/init.vim` -> `~/.config/nvim/init.vim`

* PluginInstaller: [vim-plug](https://github.com/junegunn/vim-plug)
```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### [Waybar](https://github.com/Alexays/Waybar)

### [Powerline](https://powerline.readthedocs.io/en/master/index.html)

[ ] `$DOTFILES/powerline/` -> `~/.config/powerline/`
[ ] Add the following lines to `~/.bashrc`

```bash
# ~/.bashrc

# Powerline
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/local/lib/python3.10/site-packages/powerline/bindings/bash/powerline.sh # If installed with Python
. /usr/share/powerline/bindings/bash/powerline.sh # If installed with Arch
```

### [Z script](https://github.com/rupa/z)

[ ] Add the following lines to `~/.bashrc`

```bash
# ~/.bashrc

# Z script
. /home/peterglezroa/bin/z.sh
```

### My bashrc aliases

[ ] Add the following lines to `~/.bashrc`

```bash
# Aliases
alias nvim="vim"
alias yeet="git push"
alias venv="source .venv/bin/activate"
```
