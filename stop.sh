#!/bin/bash
# ============================================================
# stop.sh - Docker 容器停止脚本
# ============================================================
# 功能：停止并删除所有 ciuzaak:latest 容器
# 
# 执行流程：
#   1. 查找所有基于 ciuzaak:latest 镜像的运行中容器
#   2. 停止这些容器
#   3. 删除已停止的容器
# 
# 使用方法：
#   bash stop.sh
# ============================================================

# 停止所有 ciuzaak:latest 容器
# docker ps -q : 只输出容器 ID
# --filter ancestor=ciuzaak:latest : 过滤基于该镜像的容器
docker stop $(docker ps -q --filter ancestor=ciuzaak:latest) 2>/dev/null

# 删除已停止的 ciuzaak:latest 容器
# docker ps -a -q : 包含已停止的容器
docker rm $(docker ps -a -q --filter ancestor=ciuzaak:latest) 2>/dev/null
