#!/bin/sh

nix-shell -p python313 --run "curl \"https://raw.githubusercontent.com/ad-oliviero/DotFiles/nixos/installation/install.py\" > install.py && sudo python ./install.py"
