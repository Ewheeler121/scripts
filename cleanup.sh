#!/bin/sh

# contains files to keep in home and deletes the rest
exclude_array=".cache .config .local Desktop Documents Downloads Music Pictures Public Templates Videos .bash_profile .bashrc"

contains_element() {
  for element in $exclude_array; do
    if [ "$element" = "$1" ]; then
      return 0
    fi
  done
  return 1
}

for item in "$HOME"/* "$HOME"/.*; do
  item_name=$(basename "$item")
  
  if ! contains_element "$item_name"; then
    rm -rf $HOME/$item_name
  fi
done

#cached files
ctpv_cache="$HOME"/.cache/ctpv
thumbnails_cache="$HOME"/.cache/thumbnails/normal

if [ -d "$ctpv_cache" ] && [ "$(ls -A "$ctpv_cache")" ]; then
    rm "$ctpv_cache"/*
fi

if [ -d "$thumbnails_cache" ] && [ "$(ls -A "$ctpv_cache")" ]; then
    rm "$thumbnails_cache"/*
fi
