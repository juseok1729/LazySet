#!/bin/bash

# 스크립트 위치 확인
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 유틸리티 스크립트 로드 (존재하는 경우)
UTILS_SCRIPT="$SCRIPT_DIR/utils.sh"
if [[ -f "$UTILS_SCRIPT" ]]; then
    source "$UTILS_SCRIPT"
else
    # 유틸리티 함수가 없는 경우 최소한의 로그 함수 정의
    log_info() { echo "ℹ️ $1"; }
    log_success() { echo "✅ $1"; }
    log_warning() { echo "⚠️ $1"; }
    log_error() { echo "❌ $1"; }
fi

# 설정 파일 디렉토리 확인
CONF_DIR=$1

if [[ -z "$CONF_DIR" ]]; then
    log_warning "설정 파일 디렉토리가 지정되지 않았습니다. 기본 설정만 사용합니다."
    CONF_DIR=""
fi

log_info "LazyVim 설치 중..."

# 기존 Neovim 구성 백업 (있는 경우)
if [[ -d ~/.config/nvim ]]; then
    BACKUP_DIR=~/.config/nvim.bak.$(date +%Y%m%d%H%M%S)
    log_warning "기존 Neovim 구성 발견: 백업을 생성합니다: $BACKUP_DIR"
    mv ~/.config/nvim $BACKUP_DIR
fi

# ~/.config 디렉토리 확인 및 생성
if [[ ! -d ~/.config ]]; then
    mkdir -p ~/.config
fi

# LazyVim 스타터 클론
log_info "LazyVim 스타터 저장소 클론 중..."
git clone https://github.com/LazyVim/starter ~/.config/nvim

# .git 디렉토리 제거
rm -rf ~/.config/nvim/.git

# 사용자 정의 설정 파일 복사 (존재하는 경우)
if [[ -n "$CONF_DIR" && -d "$CONF_DIR" ]]; then
    log_info "사용자 정의 설정 파일 복사 중..."
    
    # lua 디렉토리 확인
    if [[ ! -d ~/.config/nvim/lua/plugins ]]; then
        mkdir -p ~/.config/nvim/lua/plugins
    fi
    
    # 설정 파일 복사
    if [[ -f "$CONF_DIR/lsp.lua" ]]; then
        cp "$CONF_DIR/lsp.lua" ~/.config/nvim/lua/plugins/lsp.lua
        log_success "LSP 설정 파일이 복사되었습니다."
    fi
    
    # 이 외에도 conf 디렉토리에 있는 다른 .lua 파일도 복사
    for config_file in "$CONF_DIR"/*.lua; do
        if [[ -f "$config_file" && $(basename "$config_file") != "lsp.lua" ]]; then
            cp "$config_file" ~/.config/nvim/lua/plugins/
            log_success "$(basename "$config_file") 설정 파일이 복사되었습니다."
        fi
    done
fi

log_success "LazyVim 설치 완료"
log_info "처음 nvim을 실행하면 LazyVim이 자동으로 플러그인을 설치합니다."