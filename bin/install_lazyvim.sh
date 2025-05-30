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
    
    # Neovim 설정 복사
    if [[ -d "$CONF_DIR/nvim" ]]; then
        log_info "Neovim 설정 파일 복사 중..."
        
        # config 디렉토리 내 파일들 복사
        if [[ -d "$CONF_DIR/nvim/lua/config" ]]; then
            mkdir -p ~/.config/nvim/lua/config
            cp -r "$CONF_DIR/nvim/lua/config/"* ~/.config/nvim/lua/config/
            log_success "Neovim config 설정이 복사되었습니다."
        fi
        
        # plugins 디렉토리 내 파일들 복사
        if [[ -d "$CONF_DIR/nvim/lua/plugins" ]]; then
            mkdir -p ~/.config/nvim/lua/plugins
            cp -r "$CONF_DIR/nvim/lua/plugins/"* ~/.config/nvim/lua/plugins/
            log_success "Neovim plugins 설정이 복사되었습니다."
        fi
        
        # lazy-lock.json 복사
        if [[ -f "$CONF_DIR/nvim/lazy-lock.json" ]]; then
            cp "$CONF_DIR/nvim/lazy-lock.json" ~/.config/nvim/
            log_success "lazy-lock.json이 복사되었습니다."
        fi
        
        # lazyvim.json 복사
        if [[ -f "$CONF_DIR/nvim/lazyvim.json" ]]; then
            cp "$CONF_DIR/nvim/lazyvim.json" ~/.config/nvim/
            log_success "lazyvim.json이 복사되었습니다."
        fi
    fi
    
    # Ghostty 설정 복사
    if [[ -d "$CONF_DIR/ghostty" ]]; then
        log_info "Ghostty 설정 파일 복사 중..."
        
        if [[ "$OSTYPE" =~ ^darwin ]]; then
            # macOS
            GHOSTTY_CONFIG_DIR="$HOME/Library/Application Support/ghostty"
        else
            # Linux
            GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
        fi
        
        mkdir -p "$GHOSTTY_CONFIG_DIR"
        
        if [[ -f "$CONF_DIR/ghostty/config" ]]; then
            cp "$CONF_DIR/ghostty/config" "$GHOSTTY_CONFIG_DIR/"
            log_success "Ghostty 설정이 복사되었습니다: $GHOSTTY_CONFIG_DIR"
        fi
    fi
    
    # Vivaldi 설정 복사
    if [[ -d "$CONF_DIR/vivaldi" ]]; then
        log_info "Vivaldi 설정 파일 복사 중..."
        
        if [[ "$OSTYPE" =~ ^darwin ]]; then
            # macOS
            VIVALDI_CONFIG_DIR="$HOME/Library/Application Support/Vivaldi"
        else
            # Linux
            VIVALDI_CONFIG_DIR="$HOME/.config/vivaldi"
        fi
        
        if [[ -d "$VIVALDI_CONFIG_DIR" ]]; then
            if [[ -f "$CONF_DIR/vivaldi/Preferences" ]]; then
                # Vivaldi가 실행 중이면 설정 백업 후 복사
                if pgrep -x "vivaldi" > /dev/null; then
                    log_warning "Vivaldi가 실행 중입니다. 설정을 적용하려면 Vivaldi를 종료해주세요."
                else
                    # 기존 Preferences 백업
                    if [[ -f "$VIVALDI_CONFIG_DIR/Preferences" ]]; then
                        cp "$VIVALDI_CONFIG_DIR/Preferences" "$VIVALDI_CONFIG_DIR/Preferences.bak.$(date +%Y%m%d%H%M%S)"
                        log_info "기존 Vivaldi 설정이 백업되었습니다."
                    fi
                    
                    cp "$CONF_DIR/vivaldi/Preferences" "$VIVALDI_CONFIG_DIR/"
                    log_success "Vivaldi 설정이 복사되었습니다: $VIVALDI_CONFIG_DIR"
                fi
            fi
        else
            log_warning "Vivaldi가 설치되어 있지 않거나 설정 디렉토리를 찾을 수 없습니다."
        fi
    fi
fi

log_success "LazyVim 설치 완료"
log_info "처음 nvim을 실행하면 LazyVim이 자동으로 플러그인을 설치합니다."