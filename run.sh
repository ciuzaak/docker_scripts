#!/bin/bash
# ============================================================
# run.sh - Docker 容器启动脚本
# ============================================================
# 功能：以后台模式持久化运行 ciuzaak:latest 容器
# 
# 容器配置说明：
#   -d            : 后台运行（detach 模式）
#   -t            : 分配伪终端
#   -p 2222:22    : 将容器的 22 端口映射到主机的 2222 端口（用于 SSH 连接）
#   --gpus all    : 启用所有 GPU 支持（需要 nvidia-docker）
#   --ipc host    : 使用主机的 IPC 命名空间（PyTorch 多进程数据加载需要）
# 
# 卷挂载说明：
#   /etc/localtime:/etc/localtime:ro  : 同步主机时区（只读）
#   $HOME/root:/root               : 持久化容器的 /root 目录
#   /home:/home                       : 挂载主机的 /home 目录
# 
# 网络权限说明：
#   --cap-add NET_ADMIN   : 网络管理权限（用于 VPN/代理）
#   --cap-add NET_RAW     : 原始套接字权限（用于 ping 等）
#   --device /dev/net/tun : 挂载 TUN 设备（用于 VPN 隧道）
# 
# SSH 连接方式：
#   ssh root@localhost -p 2222
#   密码：0
# 
# 使用方法：
#   bash run.sh
# ============================================================

# 先停止旧容器
bash stop.sh

# 启动新容器
docker run -d -t \
    -p 2222:22 \
    --gpus all \
    --ipc host \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    -v "$HOME/root:/root" \
    -v /home:/home \
    --cap-add NET_ADMIN \
    --cap-add NET_RAW \
    --device /dev/net/tun:/dev/net/tun \
    ciuzaak:latest
