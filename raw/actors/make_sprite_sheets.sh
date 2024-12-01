#!/bin/zsh

aseprite=/Applications/Aseprite.app/Contents/MacOS/aseprite

for folder in */; do
	$aseprite --batch $folder*.aseprite --sheet ${folder%/}.png
done
