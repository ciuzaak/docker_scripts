# PyTorch 深度学习开发环境

基于 Docker 的 PyTorch 深度学习开发环境，支持 GPU 加速和 SSH 远程连接。

## 📋 环境配置

| 组件 | 版本 |
|------|------|
| PyTorch | 2.1.2 |
| CUDA | 11.8 |
| cuDNN | 8 |
| GCC/G++ | 11 |
| Python | 3.x |

## 📁 文件说明

| 文件 | 功能 |
|------|------|
| `Dockerfile` | Docker 镜像定义文件 |
| `build.sh` | 构建镜像并启动容器 |
| `run.sh` | 启动容器 |
| `stop.sh` | 停止并删除容器 |

## 🚀 快速开始

### 1. 构建并运行

```bash
bash build.sh
```

### 2. SSH 连接

```bash
ssh root@localhost -p 2222
# 密码: 0
```

### 3. 停止容器

```bash
bash stop.sh
```

## 🔧 容器配置

### 端口映射

| 主机端口 | 容器端口 | 用途 |
|----------|----------|------|
| 2222 | 22 | SSH |

### 卷挂载

| 主机路径 | 容器路径 | 说明 |
|----------|----------|------|
| `/home/wangzhaoze/root` | `/root` | 持久化 root 用户目录 |
| `/home` | `/home` | 共享 home 目录 |
| `/etc/localtime` | `/etc/localtime` | 同步时区（只读） |

### 特殊权限

- **GPU 支持**: `--gpus all`
- **IPC 共享**: `--ipc host` (PyTorch 多进程数据加载)
- **网络权限**: `NET_ADMIN`, `NET_RAW` (VPN/代理支持)
- **TUN 设备**: `/dev/net/tun` (VPN 隧道)

## 📦 已安装工具

### 开发工具
- `git` - 版本控制
- `vim` - 文本编辑器
- `screen` - 终端复用
- `htop` - 系统监控

### 网络工具
- `curl`, `wget` - 文件下载
- `openssh-server` - SSH 服务
- `iproute2` - 网络配置

### 其他
- `jq` - JSON 处理
- `zip`, `unzip` - 压缩工具
- 中文语言支持

## ⚠️ 注意事项

1. **GPU 支持**: 需要安装 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

2. **数据持久化**: 重要数据请保存在挂载的卷目录中

3. **安全提示**: 默认 root 密码较弱，生产环境请修改
