#!/bin/bash

# 初始化 Hugo 站点
hugo new site . --force

# 初始化 Git 仓库
git init

# 添加主题子模块
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke

# 配置主题
echo "theme = 'ananke'" >> hugo.toml

# 创建示例内容
hugo new content posts/first-post.md

# 创建 Netlify 配置文件
cat << 'EOF' > netlify.toml
[build]
  command = "hugo --gc --minify"
  publish = "public"
EOF

# 添加所有文件
git add .

# 提交更改
git commit -m "Automated Hugo setup with Netlify"

# 推送到远程仓库
if [ -n "$1" ]; then
    git remote add origin $1
    git push -u origin main
else
    echo "未提供 GitHub 仓库 URL，请手动添加远程仓库并推送"
fi
