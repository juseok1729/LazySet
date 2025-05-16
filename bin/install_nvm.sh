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

log_info "NVM 설치 중..."

# NVM 저장소 클론
git clone https://github.com/nvm-sh/nvm.git ~/.nvm && cd ~/.nvm

# 최신 태그로 체크아웃
git checkout $(git describe --tags $(git rev-list --tags --max-count=1))

# 현재 세션에 NVM 로드
source ~/.nvm/nvm.sh

# 셸 구성 파일 확인 및 NVM 설정 추가
SHELL_CONFIG=""
if [[ -f ~/.bashrc ]]; then
    SHELL_CONFIG=~/.bashrc
elif [[ -f ~/.bash_profile ]]; then
    SHELL_CONFIG=~/.bash_profile
elif [[ -f ~/.zshrc ]]; then
    SHELL_CONFIG=~/.zshrc
else
    log_warning "지원되는 셸 구성 파일을 찾을 수 없습니다. 수동으로 NVM 환경 변수를 설정하세요."
    SHELL_CONFIG=~/.bashrc
    touch $SHELL_CONFIG
fi

# NVM 환경 변수가 이미 있는지 확인
if ! grep -q 'export NVM_DIR="$HOME/.nvm"' "$SHELL_CONFIG"; then
    cat << 'EOF' >> "$SHELL_CONFIG"

# NVM 환경 설정
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
EOF
    log_success "NVM 환경 변수가 $SHELL_CONFIG에 추가되었습니다."
else
    log_info "NVM 환경 변수가 이미 $SHELL_CONFIG에 존재합니다."
fi

# 현재 셸에 적용
source "$SHELL_CONFIG" 2>/dev/null || source ~/.nvm/nvm.sh

# Node.js LTS 버전 설치
log_info "Node.js LTS 버전 설치 중..."
nvm install --lts

# Node.js 설치 확인
if command -v node &> /dev/null; then
    log_success "Node.js 설치 완료: $(node -v)"
    log_success "npm 버전: $(npm -v)"
else
    log_error "Node.js 설치 실패"
    log_info "세션을 다시 시작하거나 'source $SHELL_CONFIG' 명령어를 실행한 후 수동으로 'nvm install --lts'를 실행하세요."
fi

log_success "NVM 설치 완료"