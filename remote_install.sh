#!/bin/bash

# 원격 저장소 URL
REPO_URL="https://github.com/juseok1729/LazySet.git"
TEMP_DIR="/tmp/dev-setup-$(date +%s)"

# 간단한 색상 설정
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# 로그 함수
log_info() {
    echo -e "${BLUE}ℹ️ ${RESET}$1"
}

log_success() {
    echo -e "${GREEN}✅ ${RESET}$1"
}

log_warning() {
    echo -e "${YELLOW}⚠️ ${RESET}$1"
}

log_error() {
    echo -e "${RED}❌ ${RESET}$1"
}

# 진행 애니메이션 함수
animate_spinner() {
    local pid=$1
    local message=$2
    local spinstr='|/-\'
    local delay=0.1
    
    echo -ne "${CYAN}$message ${RESET}"
    printf "${YELLOW}%s${RESET}" "${spinstr:0:1}"  # 초기 문자 출력
    
    while ps -p $pid &>/dev/null; do
        local temp=${spinstr#?}
        sleep $delay
        printf "\b"  # 이전 문자 지우기
        printf "${YELLOW}%c${RESET}" "${spinstr:0:1}"
        spinstr=$temp${spinstr%"$temp"}
    done
    
    printf "\b"  # 마지막 문자 지우기
    echo -e "${GREEN}✅${RESET}"
}

# 명령어 실행 함수
run_with_animation() {
    local cmd="$1"
    local message="$2"
    
    # 명령 출력을 /dev/null로 리다이렉션
    eval "$cmd > /dev/null 2>&1" &
    local pid=$!
    
    animate_spinner $pid "$message"
    
    wait $pid
    local exit_status=$?
    
    if [ $exit_status -ne 0 ]; then
        log_error "$message 실패"
        return $exit_status
    fi
    
    return 0
}

log_info "개발 환경 설치 스크립트 다운로드 중..."

# Git이 설치되어 있는지 확인
if ! command -v git &> /dev/null; then
    log_warning "Git이 설치되어 있지 않습니다. 설치를 진행합니다..."
    
    # 운영체제 확인
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # 배포판 확인
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$ID
            
            if [[ "$DISTRO" == "ubuntu" || "$DISTRO" == "debian" ]]; then
                run_with_animation "sudo apt update && sudo apt install -y git" "Git 설치 중"
            elif [[ "$DISTRO" == "fedora" ]]; then
                run_with_animation "sudo dnf install -y git" "Git 설치 중"
            elif [[ "$DISTRO" == "arch" ]]; then
                run_with_animation "sudo pacman -Sy git" "Git 설치 중"
            else
                log_error "지원되지 않는 Linux 배포판입니다. Git을 수동으로 설치한 후 다시 시도해주세요."
                exit 1
            fi
        else
            log_error "배포판을 확인할 수 없습니다. Git을 수동으로 설치한 후 다시 시도해주세요."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Xcode Command Line Tools 확인 및 설치
        if ! xcode-select -p &>/dev/null; then
            log_info "Xcode Command Line Tools 설치 중..."
            xcode-select --install
            
            log_warning "Xcode Command Line Tools 설치가 진행 중입니다."
            log_warning "설치 프롬프트가 표시되면 '설치'를 클릭하고 설치가 완료될 때까지 기다려주세요."
            log_warning "설치가 완료된 후 이 스크립트를 다시 실행해주세요."
            
            exit 1
        fi
        
        # Homebrew 확인
        if ! command -v brew &> /dev/null; then
            log_info "Homebrew 설치 중..."
            run_with_animation "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" "Homebrew 설치 중"
            
            # Homebrew PATH 설정
            if [[ -f ~/.zshrc ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -f ~/.bash_profile ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
        fi
        
        run_with_animation "brew install git" "Git 설치 중"
    else
        log_error "지원되지 않는 운영체제입니다. Git을 수동으로 설치한 후 다시 시도해주세요."
        exit 1
    fi
fi

# 임시 디렉토리 생성 및 저장소 클론
mkdir -p "$TEMP_DIR"
run_with_animation "git clone \"$REPO_URL\" \"$TEMP_DIR\"" "저장소 클론 중"

if [ $? -ne 0 ]; then
    log_error "저장소 클론에 실패했습니다. URL을 확인하고 다시 시도해주세요."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# 설치 스크립트 실행
cd "$TEMP_DIR"
chmod +x install.sh
./install.sh

# 정리
log_info "임시 파일 정리 중..."
cd "$HOME"
rm -rf "$TEMP_DIR"

log_success "설치가 완료되었습니다!"