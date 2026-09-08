#!/bin/sh
# 深色：Catppuccin Frappe Teal（全局 + Konsole 联动，不碰日夜自动开关）
set -eu
plasma-apply-lookandfeel --apply Catppuccin-Frappe-Teal --keep-auto
sed -i 's/^ColorScheme=.*/ColorScheme=catppuccin-frappe/' "$HOME/.local/share/konsole/Catppuccin.profile"
echo "已切换为 Catppuccin Frappe Teal"
