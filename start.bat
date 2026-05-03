@echo off
chcp 65001 >nul
title 蛐蛐 - 启动器

echo ==============================
echo   蛐蛐 (QuQu) 启动器
echo ==============================
echo.

:: 检查 Node.js
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Node.js，请先安装 Node.js
    pause
    exit /b 1
)

:: 检查 pnpm
where pnpm >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 pnpm，请先安装: npm install -g pnpm
    pause
    exit /b 1
)

:: 检查并安装依赖
if not exist "node_modules" (
    echo [1/4] 首次运行，安装依赖...
    pnpm install
    if %errorlevel% neq 0 (
        echo [错误] 依赖安装失败
        pause
        exit /b 1
    )
) else (
    echo [1/4] 依赖已就绪
)

:: 重编译原生模块
echo [2/4] 检查原生模块...
npx @electron/rebuild -f -w better-sqlite3 >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] 原生模块编译可能有问题，尝试继续启动...
) else (
    echo [2/4] 原生模块已就绪
)

:: 检查 Python 环境
echo [3/4] 检查 Python 环境...
where uv >nul 2>&1
if %errorlevel% equ 0 (
    uv sync >nul 2>&1
    echo [3/4] Python 环境已就绪
) else (
    echo [3/4] 未找到 uv，跳过 Python 环境检查
)

:: 启动应用
echo [4/4] 启动蛐蛐...
echo.
echo ==============================
echo   应用启动中，请稍候...
echo ==============================
echo.

pnpm run dev
