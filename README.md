# Installation:

Clone the repository:
```shell
git clone https://github.com/ad-oliviero/dotfiles.git ~/dotfiles
cd dotfiles
```

Then you can install three stow packages:
```zsh
stow -d "$HOME/dotfiles/stow" -t "$HOME" -R terminal
. $HOME/.config/zsh/utils.zsh
restow
```
And the programs manually.
