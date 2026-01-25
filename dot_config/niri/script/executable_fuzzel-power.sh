#!/bin/bash
# Power Menu

SELECTIONS=" Shutdown\n󰜉 Reboot\n󰒲 Sleep\n󰗽 Logout\n󰌾 Lock"

selection=$(echo -e "$SELECTIONS" | fuzzel --dmenu --prompt="System: ")

case "$selection" in
    *Shutdown) systemctl poweroff ;;
    *Reboot) systemctl reboot ;;
    *Suspend) systemctl suspend ;;
    *Logout) niri msg action quit ;;
    *Lock) loginctl lock-session ;;
esac
