# Kops Switcher

The `kopsswitch` script lets you switch between different versions of [kops](https://kops.sigs.k8s.io/). 

## Installation

Move it to your PATH
Example:
```sh
mv kopsswitch.sh /usr/local/bin/kopsswitch
chmod +x /usr/local/bin/kopsswitch
```
Add to your .bashrc ( or .zshrc, etc)
```sh
export PATH=~/.kops/bin:$PATH
source ~/.bashrc
```

## Usage
```sh
kopsswitch 1.25.2
```
If you have file kopsswitch.txt in current folder, kopsswitch read version from it.

