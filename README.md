dotfiles
========

## Setup new pc

 - install brew (https://brew.sh/ja/)
 - install google drive
   - `brew install --cask google-drive`
   - `cd ~/Google\ Drive/マイドライブ/dev/setup && setup.sh`
 - install ghq
   - `brew install ghq`
 - install dotfiles
   - `ghq get git@github.com:oshiro-kazuma/dotfiles.git`

## Setup

### homebrew install

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### execute setup

```
make install
```

### change login shell to zsh

```
chsh -s /bin/zsh
```
