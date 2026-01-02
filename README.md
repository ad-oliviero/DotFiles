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

Or, you can do everything automatically:
1. Install [ansible](https://docs.ansible.com/) with your package manager
2. Run
  ```shell
ansible-playbook -K ~/dotfiles/ansible.yml
```

