# Windows 部署指南

> 环境要求：Node.js >= 18、pnpm、Python 3.11+（推荐用 uv 管理）

## 快速部署

```bash
# 1. 安装 Node.js 依赖
pnpm install

# 2. 为 Electron 重新编译原生模块（关键步骤！）
npx @electron/rebuild -f -w better-sqlite3

# 3. 初始化 Python 环境
uv sync

# 4. 启动（开发模式）
pnpm run dev
```

启动后应用会自动检测模型文件。如果模型未下载，点击界面中的下载按钮即可自动下载。

模型默认存储在项目内 `models/damo/` 目录下：
```
models/damo/
├── speech_paraformer-large_asr_nat-zh-cn-16k-common-vocab8404-pytorch/model.pt  (ASR ~840MB)
├── speech_fsmn_vad_zh-cn-16k-common-pytorch/model.pt                            (VAD ~1.7MB)
└── punc_ct-transformer_zh-cn-common-vocab272727-pytorch/model.pt                 (PUNC ~279MB)
```

## 为什么需要第 2 步？

pnpm 在 Windows 上与 `electron-builder install-app-deps` 的 postinstall 脚本不兼容，会导致 better-sqlite3 编译为 Node.js 版本而非 Electron 版本，启动时会报错：

```
NODE_MODULE_VERSION 137. This version of Node.js requires NODE_MODULE_VERSION 135.
```

`@electron/rebuild` 会针对项目中安装的 Electron 版本（当前为 36.5.0）重新编译原生模块。

**如果跳过此步，会出现以下症状：**
- `Electron API不可用` 错误
- `主窗口热键注册失败`
- 应用功能异常

## 生产构建

```bash
# 构建渲染进程
cd src && pnpm vite build

# 启动生产模式
npx electron .
```

## 配置 AI 模型

启动后点击齿轮图标进入设置，填入：
- **API Key**：你的 AI 服务商密钥
- **Base URL**：如 `https://dashscope.aliyuncs.com/compatible-mode/v1`（阿里云）
- **Model**：如 `qwen3-30b-a3b-instruct-2507`

## 常见问题

### Q: 启动后提示 "Electron API不可用"
**A:** 重新执行原生模块编译：
```bash
npx @electron/rebuild -f -w better-sqlite3
```

### Q: FunASR 模型未找到
**A:** 应用启动后会自动检测模型。模型默认存储在项目内 `models/damo/` 目录。
如需手动下载，确保 uv 环境已初始化：
```bash
uv sync
```

### Q: 热键注册失败
**A:** 确认没有其他应用占用了 `Ctrl+Shift+Space` 快捷键。如需修改热键，在设置中更改。
