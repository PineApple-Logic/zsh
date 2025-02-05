# zsh + tmux

My ZSH Config

## Setup

```
git clone https://github.com/PineApple-Logic/zsh.git
cd zsh
mv .zshrc ~/
zsh # this will install most of the depedances (fzf, lsd, pyenv, zinit as well as zsh plugins)
tmux
```

### Optional for tmux
```
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
```

## Get Dependencies

### Fonts

Download and install the fonts from [here](https://github.com/romkatv/powerlevel10k#fonts)
  
Finish the conversion by changing your user in /etc/passwd to /bin/zsh instead of /bin/bash

or typing `chsh $USER` and entering `/bin/zsh`

## Credit

- [DreanofAutonomy](https://github.com/dreamsofautonomy/zensh)
- [ChrisTitusTech](https://github.com/ChrisTitusTech/zsh)
