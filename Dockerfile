# ============================================================
# Dockerfile - 轻量级深度学习开发环境
# ============================================================
# 基于 Ubuntu 22.04，添加常用开发工具和 SSH 支持
# CUDA、Python 包等由 uv 和外部安装管理
# 
# 已安装工具：
#   - 编译工具: build-essential (含 gcc-11, g++-11)
#   - 网络工具: openssh-server, curl, wget, iproute2
#   - 开发工具: git, vim, screen, htop
#   - 其他: jq, zip, unzip
# 
# SSH 配置：
#   - 用户: root
#   - 密码: 0
#   - 端口: 22 (容器内)
# ============================================================

# 使用纯净的 Ubuntu 22.04 作为基础镜像
FROM ubuntu:22.04

# 设置工作目录
WORKDIR /root

# 设置环境变量
# DEBIAN_FRONTEND=noninteractive : 禁用 apt 交互式提示
# TZ=Asia/Shanghai : 设置时区为上海
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai

# ============================================================
# 安装系统依赖包
# ============================================================
# Ubuntu 22.04 自带 GCC 11，无需额外添加 PPA
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # 编译工具链（含 gcc-11, g++-11）
        build-essential \
        # Python 环境
        python3 \
        # 网络工具
        iputils-ping \
        openssh-client \
        openssh-server \
        # 开发工具
        vim \
        jq \
        git \
        wget \
        zip \
        unzip \
        screen \
        htop \
        curl \
        iproute2 \
        # 中文支持
        locales \
        language-pack-zh-hans \
        # 证书
        ca-certificates \
        # OpenCV 依赖
        libgl1-mesa-glx \
        libglib2.0-0 && \
    # 清理 apt 缓存
    rm -rf /var/lib/apt/lists/*

# 更新动态链接库缓存
RUN ldconfig

# ============================================================
# 配置 SSH 服务
# ============================================================
# 设置 root 密码为 "0"
# 允许 root 用户通过 SSH 登录
RUN echo 'root:0' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# ============================================================
# 配置中文语言环境
# ============================================================
RUN locale-gen zh_CN.UTF-8
# 如需默认使用中文，取消以下注释：
# ENV LANG=zh_CN.UTF-8 \
#     LC_ALL=zh_CN.UTF-8

# ============================================================
# 启动命令
# ============================================================
# 启动 SSH 服务并保持容器运行
CMD service ssh start && bash
