#!/bin/bash

# 스크립트 위치 확인
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_DIR="$SCRIPT_DIR/bin"
CONF_DIR="$SCRIPT_DIR/conf"

# 운영체제 확인
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    echo "💻 Linux 운영체제가 감지되었습니다."
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    echo "🍎 macOS 운영체제가 감지되었습니다."
else
    echo "❌ 지원되지 않는 운영체제입니다: $OSTYPE"
    exit 1
fi

# 머신 유형 확인
MACHINE=$(uname -m)
echo "🔧 머신 유형: $MACHINE"

# 권한 부여
chmod +x "$BIN_DIR/install_neovim.sh"
chmod +x "$BIN_DIR/install_packages.sh"
chmod +x "$BIN_DIR/install_nvm.sh"
chmod +x "$BIN_DIR/install_lazyvim.sh"

# 설치 시작
echo "🚀 설치를 시작합니다..."

# Neovim 설치
echo "📦 Neovim 설치 중..."
"$BIN_DIR/install_neovim.sh" "$OS" "$MACHINE"

# 패키지 설치
echo "📦 필요한 패키지 설치 중..."
"$BIN_DIR/install_packages.sh" "$OS"

# NVM 설치
echo "📦 NVM 설치 중..."
"$BIN_DIR/install_nvm.sh"

# LazyVim 설치
echo "📦 LazyVim 설치 중..."
"$BIN_DIR/install_lazyvim.sh" "$CONF_DIR"

echo "✅ 모든 설치가 완료되었습니다!"
echo "🎉 이제 'nvim' 명령어로 Neovim을 시작할 수 있습니다."