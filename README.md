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

## Get Dependencies

### Fonts

Download and install the fonts from [here](https://github.com/romkatv/powerlevel10k#fonts)
  
Finish the conversion by changing your user in /etc/passwd to /bin/zsh instead of /bin/bash

or typing `chsh $USER` and entering `/bin/zsh`
