#!/bin/sh
# 浅色：Catppuccin Latte Blue（全局 + Konsole 联动，不碰日夜自动开关）
set -eu
plasma-apply-lookandfeel --apply Catppuccin-Latte-Blue --keep-auto
sed -i 's/^ColorScheme=.*/ColorScheme=catppuccin-latte/' "$HOME/.local/share/konsole/Catppuccin.profile"
echo "已切换为 Catppuccin Latte Blue"
