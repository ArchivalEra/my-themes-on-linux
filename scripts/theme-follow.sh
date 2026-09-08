#!/bin/sh
# 主题跟随（事件驱动）：监听 kdeglobals 写入事件，深/浅切换时联动
# 壁纸 + fuzzel + alacritty（Konsole 由 apply-*.sh 直接处理）。
# 覆盖所有切换路径：亮度栏按钮、scripts/apply-*.sh、自动按时间切换。
# 注意：KConfig 系原子写（临时文件 rename），故监听目录而非文件本身。
set -eu
# 壁纸路径按需填写：浅色 / 深色各一张
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LIGHT_WP="$SCRIPT_DIR/../wallpapers/latte-blue.jpg"
DARK_WP="$SCRIPT_DIR/../wallpapers/frappe-teal.jpg"
FUZZEL_DIR="$HOME/.config/fuzzel"
ALACRITTY_DIR="$HOME/.config/alacritty"
KDEGLOBALS="$HOME/.config/kdeglobals"
current=""
apply_mode() {
    # $1 = light | dark
    if [ "$1" = "dark" ]; then
        plasma-apply-wallpaperimage "$DARK_WP" >/dev/null 2>&1 || true
        cp "$FUZZEL_DIR/fuzzel-frappe.ini" "$FUZZEL_DIR/fuzzel.ini"
        cp "$ALACRITTY_DIR/catppuccin-frappe-teal.toml" "$ALACRITTY_DIR/catppuccin-active.toml"
    else
        plasma-apply-wallpaperimage "$LIGHT_WP" >/dev/null 2>&1 || true
        cp "$FUZZEL_DIR/fuzzel-latte.ini" "$FUZZEL_DIR/fuzzel.ini"
        cp "$ALACRITTY_DIR/catppuccin-latte-blue.toml" "$ALACRITTY_DIR/catppuccin-active.toml"
    fi
    # 触发 alacritty 热重载
    touch "$ALACRITTY_DIR/alacritty.toml" 2>/dev/null || true
}
sync_once() {
    scheme=$(kreadconfig6 --file kdeglobals --group General --key ColorScheme 2>/dev/null || true)
    case "$scheme" in
        *Frappe* | *Macchiato* | *Mocha*) want="dark" ;;
        *) want="light" ;;
    esac
    if [ "$want" != "$current" ]; then
        apply_mode "$want"
        current="$want"
    fi
}
sync_once
# 主循环：kdeglobals 一写就 sync；inotifywait 若退出则由 systemd Restart 拉起
inotifywait -m -q -e close_write -e moved_to --format '%f' "$HOME/.config" 2>/dev/null | while read -r f; do
    [ "$f" = "kdeglobals" ] || continue
    sync_once
done
