#!/bin/bash
# ============================================================
# build.sh - Docker 镜像构建脚本
# ============================================================
# 功能：构建 ciuzaak:latest Docker 镜像
# 执行流程：
#   1. 停止并删除正在运行的旧容器
#   2. 清理已停止的容器
#   3. 构建新的 Docker 镜像
#   4. 清理悬空的旧镜像
#   5. 启动新容器
# 
# 使用方法：
#   bash build.sh
# ============================================================

# 停止旧容器
bash stop.sh

# 清理已停止的容器
docker container prune -f

# 构建 Docker 镜像，使用当前目录的 Dockerfile
docker build -t ciuzaak:latest .

# 清理悬空镜像（无标签的旧镜像）
docker image prune -f

# 启动新容器
bash run.sh
