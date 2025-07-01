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

# 创建 GitHub Actions 工作流
mkdir -p .github/workflows
cat << 'EOF' > .github/workflows/gh-pages.yml
name: GitHub Pages

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: true
          fetch-depth: 0

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          extended: true

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
EOF

# 添加所有文件
git add .

# 提交更改
git commit -m "Automated Hugo setup"

# 推送到远程仓库
if [ -n "$1" ]; then
    git remote add origin $1
    git push -u origin main
else
    echo "https://github.com/yuanfangbot/bo.git"
fi
