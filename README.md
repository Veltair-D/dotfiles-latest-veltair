# Repo overview

- This repo is where I keep the dotfiles I'm currently using, the other repo
  `https://github.com/linkarzu/dotfiles-public` is referenced in my youtube
  2024 macos workflow video series
- `https://youtube.com/playlist?list=PLZWMav2s1MZTanWwNKYvS8qgwl0HBH9J-&si=q6ByPmN8I7SOBKmX`
- My dotfiles tend to change, so I won't be modifying that other repo, so that
  youtube users can follow along and don't encounter new changes

# Update symbolic links

- Commands below will create all the files if they don't yet exist
  if they do exist, it will update them.
- `-n` allows the link to be treated as a normal file if it is a
  symlink to a directory
- `-f` "force" overwrites without warning if it already exists

## Point your zshrc file to the desired repo

```bash
ln -snf ~/github/dotfiles-public/zshrc/zshrc-file.sh ~/.zshrc >/dev/null 2>&1
source ~/.zshrc
```

```bash
ln -snf ~/github/dotfiles-latest/zshrc/zshrc-file.sh ~/.zshrc >/dev/null 2>&1
source ~/.zshrc
```

```bash
# This is on the other repo where I keep my ssh config files
ln -snf ~/github/dotfiles/sshconfig-pers ~/.ssh/config >/dev/null 2>&1
```
