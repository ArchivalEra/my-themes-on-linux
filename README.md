# Catppuccin 主题仓库

本机：Debian sid + Plasma 6.7.4 + cachyos 7.2.3 内核（2026-09-08 落地）。

## 目录

| 目录 | 上游 | 用途 |
|---|---|---|
| `kde/` | `catppuccin/kde` | 全局主题 + 配色 + Aurorae 窗饰 + Splash + 光标 |
| `konsole/` | `catppuccin/konsole` | 终端配色 |
| `fuzzel/` | `catppuccin/fuzzel` | 启动器配色（Latte Blue / Frappe Teal） |
| `alacritty/` | `catppuccin/alacritty` | Alacritty 0.17 官方风味文件 |
| `zen-browser/` | `catppuccin/zen-browser` | 未应用 |
| `scripts/` | 自写 | 一键切换浅/深 |
| `wallpapers/` | 两张图 | 浅色 latte-blue.jpg / 深色 frappe-teal.jpg |

上游目录不要手改，升级用 `git pull`。

## 已安装（`./install.sh <flavour> <accent> <windec> auto`）

- 浅色：`4 13 1` → Latte + Blue + Modern（`Catppuccin-Latte-Blue`）
- 深色：`3 10 1` → Frappe + Teal + Modern（`Catppuccin-Frappe-Teal`）

## 亮度栏深浅按钮的绑定

`kdeglobals [KDE]`：

```ini
DefaultLightLookAndFeel=Catppuccin-Latte-Blue
DefaultDarkLookAndFeel=Catppuccin-Frappe-Teal
AutomaticLookAndFeel=false   # 只手动按按钮，不按时间自动切
```

按钮文案取目标主题 `metadata.json` 的 `Name`：
浅色下显示「切换为 Catppuccin Frappe Teal」，深色下显示「切换为 Catppuccin Latte Blue」。

## Konsole

- 配色文件：`~/.local/share/konsole/catppuccin-{latte,frappe}.colorscheme`
- 默认配置：`~/.local/share/konsole/Catppuccin.profile`（`konsolerc [Desktop Entry] DefaultProfile` 指向它）
- 注意：亮度栏按钮只切全局主题，Konsole 配色需用 `scripts/apply-*.sh` 联动，或终端里手动换。

## 跟随服务（壁纸 + fuzzel + alacritty 自动切）

- 机制：`scripts/theme-follow.sh` 用 inotify 监听 `~/.config/kdeglobals` 写入事件
  （KConfig 原子写，故监听目录；inotify-tools 提供 `inotifywait`），
  事件触发才读 `ColorScheme` 做深/浅联动，无轮询。
  （用户 systemd 服务 `catppuccin-theme-follow.service` 常驻，开机自启），
  按亮度栏按钮、跑脚本、开自动切换都会联动，无需手动换。
- 壁纸源文件：`wallpapers/latte-blue.jpg`（浅）/ `wallpapers/frappe-teal.jpg`（深）
- fuzzel：`~/.config/fuzzel/fuzzel.ini`（活动文件），
  `fuzzel-latte.ini` / `fuzzel-frappe.ini` 为两套完整配置（含 `[main]` + `[border]`）。
- alacritty：`~/.config/alacritty/alacritty.toml` 经 `general.import`
  引用 `catppuccin-active.toml`；`catppuccin-latte-blue.toml` /
  `catppuccin-frappe-teal.toml` 为完整风味 + Blue/Teal 点缀覆盖
 （光标 + 选区），切换后 touch 主配置触发热重载。
- 注意：曾试过动态壁纸包方案（仿官方 Next 的 `images/` + `images_dark/`），
  6.7 的 image 后端不认用户目录的包（unknown provider），已废弃；
  两套全局主题 defaults 里的 `[Wallpaper]` 段也已移除（同版本不生效）。

## 一键切换

```sh
./scripts/apply-light.sh   # Latte Blue（全局 + Konsole）
./scripts/apply-dark.sh    # Frappe Teal（全局 + Konsole）
```

## 恢复

```sh
plasma-apply-lookandfeel --apply org.kde.breeze.desktop
```
