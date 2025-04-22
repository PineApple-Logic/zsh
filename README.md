# zsh + tmux

My ZSH Config


## Get Dependencies

```
sudo apt install lsd zsh
```

### Fonts

Download and install the fonts from [here](https://github.com/romkatv/powerlevel10k#fonts)
  
Finish the conversion by changing your user in /etc/passwd to /bin/zsh instead of /bin/bash

or typing `chsh $USER` and entering `/bin/zsh`

## Setup

```
git clone https://github.com/PineApple-Logic/zsh.git
cd zsh
mv .zshrc ~/
zsh
```

### Optional for tmux
```
sudo apt install tmux
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
tmux
```
## Credit

- [DreanofAutonomy](https://github.com/dreamsofautonomy/zensh)
- [ChrisTitusTech](https://github.com/ChrisTitusTech/zsh)
