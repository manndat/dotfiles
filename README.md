dotfiles
===

Here are my dotfiles, use them as you like, improve them as you like,
suggest improvements as you like, personalize them as you like.

## Setup
Never run code from the internet without checking what it does! *However,
if you really want to install it automatically, run this:*
> **_Warning:_** the installer script is rather buggy, use it with care
> and backup your dotfiles first!! I am not responsible if the installer
> is not backing up your files!

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/cheriimoya/dotfiles/master/bootstrap-script.sh)"
```
---
You can also just `git clone "https://github.com/cheriimoya/dotfiles"` this
repo and start the installer with `~/dotfiles/bootstrap-script.sh`.

---
Also, you could just `grep -r '{{'` inside the folder after cloning, substitute
the results and link `ln -s dotfiles/zshrc ~/.zshrc` (etc) from your home
directory.

## Bugs
I know there are some bugs but i am just too lazy to fix them. If you are
really engaged, feel free to open an issue, i'll look into it.
