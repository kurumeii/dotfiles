#!/bin/bash
# Fuzzel Master Control Center

SCRIPTS_DIR="$HOME/.config/niri/script/"

MENU="󰅇 Clipboard\n󰍯 Audio\n󰱨 Emoji\n󰂯 Bluetooth\n󰐥 Power"

selection=$(echo -e "$MENU" | fuzzel --dmenu --prompt="Hub: ")

case "$selection" in
    *Clipboard) "$SCRIPTS_DIR/fuzzel-clipboard.sh" ;;
    *Audio)     "$SCRIPTS_DIR/fuzzel-audio.sh" ;;
    *Search)    "$SCRIPTS_DIR/fuzzel-search.sh" ;;
    *Emoji)     "$SCRIPTS_DIR/fuzzel-emoji.sh" ;;
    *Bluetooth) blueman-manager ;;
    *Power)     "$SCRIPTS_DIR/fuzzel-power.sh" ;;
esac
