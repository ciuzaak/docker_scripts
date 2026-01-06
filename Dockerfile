# ============================================================
# Dockerfile - PyTorch 深度学习开发环境
# ============================================================
# 基于 PyTorch 官方镜像，添加常用开发工具和 SSH 支持
# 
# 基础环境：
#   - PyTorch 2.1.2
#   - CUDA 11.8
#   - cuDNN 8
#   - Python 3
# 
# 已安装工具：
#   - 编译工具: build-essential, gcc-11, g++-11
#   - 网络工具: openssh-server, curl, wget, iproute2
#   - 开发工具: git, vim, screen, htop
#   - 其他: jq, zip, unzip
# 
# SSH 配置：
#   - 用户: root
#   - 密码: 0
#   - 端口: 22 (容器内)
# ============================================================

# 使用 PyTorch 官方运行时镜像作为基础
FROM pytorch/pytorch:2.1.2-cuda11.8-cudnn8-runtime

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
# 使用单个 RUN 命令减少镜像层数
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # 包管理工具
        software-properties-common \
        # 编译工具链
        build-essential \
        # Python 环境
        python3 \
        python3-pip \
        # 系统工具
        binutils \
        libstdc++6 \
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
    # 添加 Ubuntu Toolchain PPA 并安装 GCC 11
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y gcc-11 g++-11 && \
    # 设置 GCC 11 为默认编译器
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100 && \
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
