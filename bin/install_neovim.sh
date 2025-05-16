#!/bin/bash

# 인자 확인
OS=$1
MACHINE=$2

if [[ -z "$OS" || -z "$MACHINE" ]]; then
    echo "❌ 오류: 운영체제와 머신 유형이 필요합니다."
    exit 1
fi

# Neovim 설치
if [[ "$OS" == "linux" ]]; then
    echo "🐧 Linux용 Neovim 설치 중..."
    
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    
    # /usr/local/bin에 심볼릭 링크 생성
    echo "🔗 심볼릭 링크 생성 중..."
    sudo mkdir -p /usr/local/bin
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    
    # PATH 추가 (이미 있는지 확인)
    if ! grep -q 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' ~/.bashrc; then
        echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
    fi
    
    # 현재 셸에 PATH 추가
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
    
    rm nvim-linux-x86_64.tar.gz
    
    echo "✅ Linux용 Neovim 설치 완료"

elif [[ "$OS" == "macos" ]]; then
    echo "🍎 macOS용 Neovim 설치 중..."
    
    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-$MACHINE.tar.gz
    tar xzf nvim-macos-$MACHINE.tar.gz
    
    # 설치 디렉토리 생성 및 이동
    sudo mkdir -p /usr/local/bin
    sudo mv nvim-macos-$MACHINE/bin/nvim /usr/local/bin/
    
    # 필요한 디렉토리 이동
    sudo mkdir -p /usr/local/share/nvim
    sudo cp -r nvim-macos-$MACHINE/share/nvim/* /usr/local/share/nvim/
    
    # 임시 파일 정리
    rm -rf nvim-macos-$MACHINE.tar.gz nvim-macos-$MACHINE
    
    echo "✅ macOS용 Neovim 설치 완료"
else
    echo "❌ 지원되지 않는 운영체제입니다: $OS"
    exit 1
fi

# 설치 확인
if command -v nvim &> /dev/null; then
    echo "✅ Neovim 설치 버전: $(nvim --version | head -n 1)"
    echo "✅ Neovim 명령어 경로: $(which nvim)"
else
    echo "⚠️ Neovim이 설치되었지만 PATH에 추가되지 않았습니다."
    echo "⚠️ 다음 명령어로 Neovim을 직접 실행할 수 있습니다: /usr/local/bin/nvim"
    echo "🔄 세션을 다시 시작하거나 'source ~/.bashrc' 명령어를 실행해주세요."
fi