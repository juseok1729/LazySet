#!/bin/bash

# 스크립트 위치 확인
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_DIR="$SCRIPT_DIR/bin"
CONF_DIR="$SCRIPT_DIR/conf"

# 유틸리티 스크립트 로드
source "$BIN_DIR/utils.sh"

# 운영체제 확인
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    log_info "Linux 운영체제가 감지되었습니다."
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    log_info "macOS 운영체제가 감지되었습니다."
else
    log_error "지원되지 않는 운영체제입니다: $OSTYPE"
    exit 1
fi

# 머신 유형 확인
MACHINE=$(uname -m)
log_info "머신 유형: $MACHINE"

# 권한 부여
chmod +x "$BIN_DIR/install_neovim.sh"
chmod +x "$BIN_DIR/install_packages.sh"
chmod +x "$BIN_DIR/install_nvm.sh"
chmod +x "$BIN_DIR/install_lazyvim.sh"
chmod +x "$BIN_DIR/utils.sh"

# 애니메이션 유형 설정 (spinner, emoji, progress, none 중 선택)
set_animation_type "emoji"

# 설치 시작
log_info "설치를 시작합니다..."

# 로그 수준 설정 (quiet 모드 - 설치 로그 숨김)
export INSTALL_LOG_LEVEL="quiet"

# Neovim 설치
log_info "Neovim 설치 준비 중..."
run_with_animation "$BIN_DIR/install_neovim.sh \"$OS\" \"$MACHINE\"" "Neovim 설치 중" 15

# 패키지 설치
log_info "필요한 패키지 설치 준비 중..."
run_with_animation "$BIN_DIR/install_packages.sh \"$OS\"" "패키지 설치 중" 20

# NVM 설치
log_info "NVM 설치 준비 중..."
run_with_animation "$BIN_DIR/install_nvm.sh" "NVM 설치 중" 10

# LazyVim 설치
log_info "LazyVim 설치 준비 중..."
run_with_animation "$BIN_DIR/install_lazyvim.sh \"$CONF_DIR\"" "LazyVim 설치 중" 8

log_success "모든 설치가 완료되었습니다!"
log_success "이제 'nvim' 명령어로 Neovim을 시작할 수 있습니다."