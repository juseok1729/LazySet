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

# vi alias를 추가하는 함수
add_vi_alias() {
    # 사용자의 셸 설정 파일 확인
    local SHELL_CONFIG=""
    if [[ -f ~/.bashrc ]]; then
        SHELL_CONFIG=~/.bashrc
    elif [[ -f ~/.bash_profile ]]; then
        SHELL_CONFIG=~/.bash_profile
    elif [[ -f ~/.zshrc ]]; then
        SHELL_CONFIG=~/.zshrc
    else
        log_warning "셸 설정 파일을 찾을 수 없습니다. vi alias를 수동으로 추가해주세요."
        return
    fi

    # vi alias가 이미 있는지 확인
    if ! grep -q "alias vi='nvim'" "$SHELL_CONFIG"; then
        log_info "vi alias를 $SHELL_CONFIG에 추가하는 중..."
        echo -e "\n# Neovim as vi alias\nalias vi='nvim'" >> "$SHELL_CONFIG"
        log_success "vi alias가 추가되었습니다."
    else
        log_info "vi alias가 이미 $SHELL_CONFIG에 존재합니다."
    fi

    # vim alias도 추가
    if ! grep -q "alias vim='nvim'" "$SHELL_CONFIG"; then
        echo "alias vim='nvim'" >> "$SHELL_CONFIG"
    fi
}

# 인자 확인
OS=$1
MACHINE=$2

if [[ -z "$OS" || -z "$MACHINE" ]]; then
    log_error "오류: 운영체제와 머신 유형이 필요합니다."
    exit 1
fi

# Neovim 설치
if [[ "$OS" == "linux" ]]; then
    log_info "Linux용 Neovim 설치 중..."
    
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    
    # /usr/local/bin에 심볼릭 링크 생성
    log_info "심볼릭 링크 생성 중..."
    sudo mkdir -p /usr/local/{bin,lib,share}
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    sudo ln -sf /opt/nvim-linux-x86_64/lib/nvim /usr/local/lib/nvim
    sudo ln -sf /opt/nvim-linux-x86_64/share/nvim /usr/local/share/nvim
    
    # PATH 추가 (이미 있는지 확인)
    if ! grep -q 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' ~/.bashrc; then
        echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
    fi
    
    # vi alias 추가
    add_vi_alias
    
    # 현재 셸에 PATH 추가
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
    
    rm nvim-linux-x86_64.tar.gz
    
    log_success "Linux용 Neovim 설치 완료"

elif [[ "$OS" == "macos" ]]; then
    log_info "macOS용 Neovim 설치 중..."
    
    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-$MACHINE.tar.gz
    tar xzf nvim-macos-$MACHINE.tar.gz
    
    # 설치 디렉토리 생성 및 이동
    sudo mkdir -p /usr/local/{bin,lib,share}
    sudo mv nvim-macos-$MACHINE/bin/nvim /usr/local/bin/
    sudo mv nvim-macos-$MACHINE/lib/nvim /usr/local/lib/
    sudo mv nvim-macos-$MACHINE/share/nvim /usr/local/share/
    
    # 임시 파일 정리
    rm -rf nvim-macos-$MACHINE.tar.gz nvim-macos-$MACHINE
    
    # vi alias 추가
    add_vi_alias
    
    log_success "macOS용 Neovim 설치 완료"
else
    log_error "지원되지 않는 운영체제입니다: $OS"
    exit 1
fi

# 설치 확인
if command -v nvim &> /dev/null; then
    log_success "Neovim 설치 버전: $(nvim --version | head -n 1)"
    log_success "Neovim 명령어 경로: $(which nvim)"
    
    # 현재 세션에 alias 추가
    alias vi='nvim'
    alias vim='nvim'
    log_success "현재 세션에 vi 및 vim alias가 추가되었습니다."
    log_info "모든 터미널에서 alias를 사용하려면 셸을 다시 시작하거나 설정 파일을 로드하세요: source ~/.bashrc"
else
    log_warning "Neovim이 설치되었지만 PATH에 추가되지 않았습니다."
    log_warning "다음 명령어로 Neovim을 직접 실행할 수 있습니다: /usr/local/bin/nvim"
    log_info "세션을 다시 시작하거나 'source ~/.bashrc' 명령어를 실행해주세요."
fi