#!/bin/bash

# 인자 확인
OS=$1

if [[ -z "$OS" ]]; then
    echo "❌ 오류: 운영체제 정보가 필요합니다."
    exit 1
fi

# 패키지 설치
if [[ "$OS" == "linux" ]]; then
    echo "🐧 Linux용 패키지 설치 중..."
    
    # 배포판 확인
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        echo "❌ 배포판을 확인할 수 없습니다."
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
        echo "⚠️ 지원되지 않는 Linux 배포판입니다: $DISTRO"
        echo "⚠️ 수동으로 ripgrep, fzf, fd, git, gcc를 설치해주세요."
    fi
    
    echo "✅ Linux용 패키지 설치 완료"

elif [[ "$OS" == "macos" ]]; then
    echo "🍎 macOS용 패키지 설치 중..."
    
    # Xcode Command Line Tools 확인 및 설치
    if ! xcode-select -p &>/dev/null; then
        echo "🔨 Xcode Command Line Tools 설치 중..."
        xcode-select --install
        
        echo "⚠️ Xcode Command Line Tools 설치가 진행 중입니다."
        echo "⚠️ 설치 프롬프트가 표시되면 '설치'를 클릭하고 설치가 완료될 때까지 기다려주세요."
        echo "⚠️ 설치가 완료된 후 이 스크립트를 다시 실행해주세요."
        
        # 사용자에게 CLT 설치 확인을 요청
        read -p "Xcode Command Line Tools 설치가 완료되었나요? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "❌ 설치를 중단합니다. Xcode Command Line Tools 설치 후 다시 시도해주세요."
            exit 1
        fi
    else
        echo "✅ Xcode Command Line Tools가 이미 설치되어 있습니다."
    fi
    
    # Homebrew 설치 확인
    if ! command -v brew &> /dev/null; then
        echo "🍺 Homebrew 설치 중..."
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
    
    echo "✅ macOS용 패키지 설치 완료"
else
    echo "❌ 지원되지 않는 운영체제입니다: $OS"
    exit 1
fi

# 설치 확인
echo "📋 설치된 패키지 버전:"
if command -v ripgrep &> /dev/null; then
    echo "✅ ripgrep: $(rg --version | head -n 1)"
elif command -v rg &> /dev/null; then
    echo "✅ ripgrep: $(rg --version | head -n 1)"
else
    echo "❌ ripgrep 설치 실패"
fi

if command -v fzf &> /dev/null; then
    echo "✅ fzf: $(fzf --version)"
else
    echo "❌ fzf 설치 실패"
fi

if command -v fd &> /dev/null; then
    echo "✅ fd: $(fd --version)"
else
    echo "❌ fd 설치 실패"
fi

if command -v git &> /dev/null; then
    echo "✅ git: $(git --version)"
else
    echo "❌ git 설치 실패"
fi

if command -v gcc &> /dev/null; then
    echo "✅ gcc: $(gcc --version | head -n 1)"
else
    echo "❌ gcc 설치 실패"
fi