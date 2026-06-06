#!/bin/bash

dots=("qutebrowser" "foot" "niri" "waybar" "wayshot" "yazi" "kitty" "mako" "nvim" "swaylock" "weathr" "rofi" "lsd")
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 处理 ~/.config 下的目录
for dot in "${dots[@]}"; do
    target="$HOME/.config/$dot"
    source="$HOME/dotfiles/$dot"

    # 如果目标已存在且不是符号链接，则备份
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "备份 $target 到 $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    elif [ -L "$target" ]; then
        # 如果已经是链接，直接删除（后面会重建）
        rm "$target"
    fi

    # 确保源目录存在（如果 dotfiles 里还没有这个配置，请先手动放一份）
    if [ ! -e "$source" ]; then
        echo "警告: $source 不存在，跳过链接 $target"
        continue
    fi

    # 创建符号链接
    ln -s "$source" "$target"
    echo "已链接 $target -> $source"
done

# 处理家目录下的点文件
home_files=(".zshrc" ".bashrc" ".vimrc")
for file in "${home_files[@]}"; do
    target="$HOME/$file"
    source="$HOME/dotfiles/$file"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "备份 $target 到 $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    elif [ -L "$target" ]; then
        rm "$target"
    fi

    if [ ! -e "$source" ]; then
        echo "警告: $source 不存在，跳过链接 $target"
        continue
    fi

    ln -s "$source" "$target"
    echo "已链接 $target -> $source"
done

cd "$HOME/dotfiles" || exit
git add --all
echo "所有操作完成，备份文件位于 $BACKUP_DIR"#!/bin/bash

dots=("qutebrowser" "foot" "niri" "waybar" "wayshot" "yazi" "kitty" "mako" "nvim" "swaylock" "weathr")
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 处理 ~/.config 下的目录
for dot in "${dots[@]}"; do
    target="$HOME/.config/$dot"
    source="$HOME/dotfiles/$dot"

    # 如果目标已存在且不是符号链接，则备份
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "备份 $target 到 $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    elif [ -L "$target" ]; then
        # 如果已经是链接，直接删除（后面会重建）
        rm "$target"
    fi

    # 确保源目录存在（如果 dotfiles 里还没有这个配置，请先手动放一份）
    if [ ! -e "$source" ]; then
        echo "警告: $source 不存在，跳过链接 $target"
        continue
    fi

    # 创建符号链接
    ln -s "$source" "$target"
    echo "已链接 $target -> $source"
done

# 处理家目录下的点文件
home_files=(".zshrc" ".bashrc" ".vimrc")
for file in "${home_files[@]}"; do
    target="$HOME/$file"
    source="$HOME/dotfiles/$file"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "备份 $target 到 $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    elif [ -L "$target" ]; then
        rm "$target"
    fi

    if [ ! -e "$source" ]; then
        echo "警告: $source 不存在，跳过链接 $target"
        continue
    fi

    ln -s "$source" "$target"
    echo "已链接 $target -> $source"
done

cd "$HOME/dotfiles" || exit
git add --all
echo "所有操作完成，备份文件位于 $BACKUP_DIR"#!/bin/bash

dots=("qutebrowser" "foot" "niri" "waybar" "wayshot" "yazi" "kitty" "mako" "nvim" "swaylock" "weathr")
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 处理 ~/.config 下的目录
for dot in "${dots[@]}"; do
    target="$HOME/.config/$dot"
    source="$HOME/dotfiles/$dot"

    # 如果目标已存在且不是符号链接，则备份
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "备份 $target 到 $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    elif [ -L "$target" ]; then
        # 如果已经是链接，直接删除（后面会重建）
        rm "$target"
    fi

    # 确保源目录存在（如果 dotfiles 里还没有这个配置，请先手动放一份）
    if [ ! -e "$source" ]; then
        echo "警告: $source 不存在，跳过链接 $target"
        continue
    fi

    # 创建符号链接
    ln -s "$source" "$target"
    echo "已链接 $target -> $source"
done

# 处理家目录下的点文件
home_files=(".zshrc" ".bashrc" ".vimrc")
for file in "${home_files[@]}"; do
    target="$HOME/$file"
    source="$HOME/dotfiles/$file"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "备份 $target 到 $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    elif [ -L "$target" ]; then
        rm "$target"
    fi

    if [ ! -e "$source" ]; then
        echo "警告: $source 不存在，跳过链接 $target"
        continue
    fi

    ln -s "$source" "$target"
    echo "已链接 $target -> $source"
done

cd "$HOME/dotfiles" || exit
git add --all
echo "所有操作完成，备份文件位于 $BACKUP_DIR"
