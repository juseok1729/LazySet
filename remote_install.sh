#!/bin/bash

# 원격 저장소 URL
REPO_URL="https://github.com/juseok1729/LazySet.git"
TEMP_DIR="/tmp/dev-setup-$(date +%s)"

echo "🚀 개발 환경 설치 스크립트 다운로드 중..."

# Git이 설치되어 있는지 확인
if ! command -v git &> /dev/null; then
    echo "⚠️ Git이 설치되어 있지 않습니다. 설치를 진행합니다..."
    
    # 운영체제 확인
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # 배포판 확인
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$ID
            
            if [[ "$DISTRO" == "ubuntu" || "$DISTRO" == "debian" ]]; then
                sudo apt update && sudo apt install -y git
            elif [[ "$DISTRO" == "fedora" ]]; then
                sudo dnf install -y git
            elif [[ "$DISTRO" == "arch" ]]; then
                sudo pacman -Sy git
            else
                echo "❌ 지원되지 않는 Linux 배포판입니다. Git을 수동으로 설치한 후 다시 시도해주세요."
                exit 1
            fi
        else
            echo "❌ 배포판을 확인할 수 없습니다. Git을 수동으로 설치한 후 다시 시도해주세요."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Homebrew 확인
        if ! command -v brew &> /dev/null; then
            echo "🍺 Homebrew 설치 중..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install git
    else
        echo "❌ 지원되지 않는 운영체제입니다. Git을 수동으로 설치한 후 다시 시도해주세요."
        exit 1
    fi
fi

# 임시 디렉토리 생성 및 저장소 클론
mkdir -p "$TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR"

if [ $? -ne 0 ]; then
    echo "❌ 저장소 클론에 실패했습니다. URL을 확인하고 다시 시도해주세요."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# 설치 스크립트 실행
cd "$TEMP_DIR"
chmod +x install.sh
./install.sh

# 정리
echo "🧹 임시 파일 정리 중..."
cd "$HOME"
rm -rf "$TEMP_DIR"

echo "✅ 설치가 완료되었습니다!"