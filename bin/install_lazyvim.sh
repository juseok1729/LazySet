#!/bin/bash

# 설정 파일 디렉토리 확인
CONF_DIR=$1

if [[ -z "$CONF_DIR" ]]; then
    echo "⚠️ 설정 파일 디렉토리가 지정되지 않았습니다. 기본 설정만 사용합니다."
    CONF_DIR=""
fi

echo "🚀 LazyVim 설치 중..."

# 기존 Neovim 구성 백업 (있는 경우)
if [[ -d ~/.config/nvim ]]; then
    BACKUP_DIR=~/.config/nvim.bak.$(date +%Y%m%d%H%M%S)
    echo "⚠️ 기존 Neovim 구성 발견: 백업을 생성합니다: $BACKUP_DIR"
    mv ~/.config/nvim $BACKUP_DIR
fi

# ~/.config 디렉토리 확인 및 생성
if [[ ! -d ~/.config ]]; then
    mkdir -p ~/.config
fi

# LazyVim 스타터 클론
echo "📦 LazyVim 스타터 저장소 클론 중..."
git clone https://github.com/LazyVim/starter ~/.config/nvim

# .git 디렉토리 제거
rm -rf ~/.config/nvim/.git

# 사용자 정의 설정 파일 복사 (존재하는 경우)
if [[ -n "$CONF_DIR" && -d "$CONF_DIR" ]]; then
    echo "📄 사용자 정의 설정 파일 복사 중..."
    
    # lua 디렉토리 확인
    if [[ ! -d ~/.config/nvim/lua/plugins ]]; then
        mkdir -p ~/.config/nvim/lua/plugins
    fi
    
    # 설정 파일 복사
    if [[ -f "$CONF_DIR/lsp.lua" ]]; then
        cp "$CONF_DIR/lsp.lua" ~/.config/nvim/lua/plugins/lsp.lua
        echo "✅ LSP 설정 파일이 복사되었습니다."
    fi
    
    # 이 외에도 conf 디렉토리에 있는 다른 .lua 파일도 복사
    for config_file in "$CONF_DIR"/*.lua; do
        if [[ -f "$config_file" && $(basename "$config_file") != "lsp.lua" ]]; then
            cp "$config_file" ~/.config/nvim/lua/plugins/
            echo "✅ $(basename "$config_file") 설정 파일이 복사되었습니다."
        fi
    done
fi

echo "✅ LazyVim 설치 완료"
echo "ℹ️ 처음 nvim을 실행하면 LazyVim이 자동으로 플러그인을 설치합니다."