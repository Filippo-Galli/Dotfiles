#!/bin/bash
sudo mv /usr/bin/$1 /usr/bin/$1.original
a="/usr/bin/" 
a+=$1
a+=.original
a+=' --enable-features=UseOzonePlatform --ozone-platform=wayland "$1"'
echo "$a" | sudo tee /usr/bin/$1
sudo chmod +x /usr/bin/$1

