apt-get install neovim curl -y
# Install plugin manager
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# copy vimrc
mkdir /home/peterglezroa/.config/nvim
ln -s $PWD/vimrc /home/peterglezroa/.config/nvim/init.vim
chown -R peterglezroa: /home/peterglezroa/.config/nvim
echo "REMEMBER TO RUN :PlugInstall to install plugins!"
