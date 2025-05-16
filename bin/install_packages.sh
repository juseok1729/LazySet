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

# 인자 확인
OS=$1

if [[ -z "$OS" ]]; then
    log_error "오류: 운영체제 정보가 필요합니다."
    exit 1
fi

# 패키지 설치
if [[ "$OS" == "linux" ]]; then
    log_info "Linux용 패키지 설치 중..."
    
    # 배포판 확인
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        log_error "배포판을 확인할 수 없습니다."
        exit 1
    fi
    
    # 배포판에 따른 설치
    if [[ "$DISTRO" == "ubuntu" || "$DISTRO" == "debian" ]]; then
        sudo apt update
        sudo apt install -y ripgrep fzf fd-find git gcc build-essential
        
        # fd-find를 fd로 심볼릭 링크 생성
        if ! command -v fd &> /dev/null; then
            sudo ln -s $(which fdfind) /usr/local/bin/fd
        fi
    elif [[ "$DISTRO" == "fedora" ]]; then
        sudo dnf install -y ripgrep fzf fd-find git gcc gcc-c++ make
    elif [[ "$DISTRO" == "arch" ]]; then
        sudo pacman -Sy ripgrep fzf fd git gcc
    else
        log_warning "지원되지 않는 Linux 배포판입니다: $DISTRO"
        log_warning "수동으로 ripgrep, fzf, fd, git, gcc를 설치해주세요."
    fi
    
    log_success "Linux용 패키지 설치 완료"

elif [[ "$OS" == "macos" ]]; then
    log_info "macOS용 패키지 설치 중..."
    
    # Xcode Command Line Tools 확인 및 설치
    if ! xcode-select -p &>/dev/null; then
        log_info "Xcode Command Line Tools 설치 중..."
        xcode-select --install
        
        log_warning "Xcode Command Line Tools 설치가 진행 중입니다."
        log_warning "설치 프롬프트가 표시되면 '설치'를 클릭하고 설치가 완료될 때까지 기다려주세요."
        
        # 사용자에게 CLT 설치 확인을 요청
        read -p "Xcode Command Line Tools 설치가 완료되었나요? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_error "설치를 중단합니다. Xcode Command Line Tools 설치 후 다시 시도해주세요."
            exit 1
        fi
    else
        log_success "Xcode Command Line Tools가 이미 설치되어 있습니다."
    fi
    
    # Homebrew 설치 확인
    if ! command -v brew &> /dev/null; then
        log_info "Homebrew 설치 중..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Homebrew PATH 설정
        if [[ -f ~/.zshrc ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f ~/.bash_profile ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f ~/.bashrc ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bashrc
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    
    # 패키지 설치
    brew install fzf fd ripgrep git gcc
    
    log_success "macOS용 패키지 설치 완료"
else
    log_error "지원되지 않는 운영체제입니다: $OS"
    exit 1
fi

# 설치 확인
log_info "설치된 패키지 버전:"
if command -v ripgrep &> /dev/null; then
    log_success "ripgrep: $(rg --version | head -n 1)"
elif command -v rg &> /dev/null; then
    log_success "ripgrep: $(rg --version | head -n 1)"
else
    log_error "ripgrep 설치 실패"
fi

if command -v fzf &> /dev/null; then
    log_success "fzf: $(fzf --version)"
else
    log_error "fzf 설치 실패"
fi

if command -v fd &> /dev/null; then
    log_success "fd: $(fd --version)"
else
    log_error "fd 설치 실패"
fi

if command -v git &> /dev/null; then
    log_success "git: $(git --version)"
else
    log_error "git 설치 실패"
fi

if command -v gcc &> /dev/null; then
    log_success "gcc: $(gcc --version | head -n 1)"
else
    log_error "gcc 설치 실패"
fi