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
set_animation_type "spinner"

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

# 설치 완료
log_success "모든 설치가 완료되었습니다!"
log_success "이제 'nvim', 'vi' 또는 'vim' 명령어로 Neovim을 시작할 수 있습니다."

# 시스템 전체 alias 설정 안내
log_info "시스템 전체에 vi/vim alias를 설정하려면 다음 명령을 실행하세요:"
log_info "  sudo ./set_system_aliases.sh"

# 설치 완료 후 현재 셸에 alias 추가
alias vi='nvim'
alias vim='nvim'
log_info "현재 세션에 'vi' 및 'vim' 별칭이 추가되었습니다."
log_info "새 터미널에서도 별칭을 사용하려면 'source ~/.bashrc' 명령어를 실행하거나 새 터미널을 열어주세요."