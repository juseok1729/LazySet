#!/bin/bash

# 유틸리티 함수 모음

# 기본 애니메이션 유형 설정
ANIMATION_TYPE="spinner"  # 기본값: emoji (spinner, emoji, progress 중 선택 가능)

# 컬러 설정
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# 스피너 애니메이션 함수
show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    
    echo -ne " "  # 스피너 자리 확보
    
    while ps -p $pid &>/dev/null; do
        local temp=${spinstr#?}
        echo -ne "\b${spinstr:0:1}"  # 백스페이스 후 첫 문자 출력
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    
    echo -ne "\b "  # 스피너 지우기
}

# 이모지 로딩 애니메이션 함수
show_emoji_loading() {
    local pid=$1
    local title=$2
    local emojis=("🔄" "⚙️" "📦" "🚀" "✨" "🔨" "🛠️" "📝")
    local i=0
    
    # 타이틀 출력
    echo -ne "${CYAN}$title ${RESET}"
    
    # 첫 번째 이모지 출력
    echo -ne "${YELLOW}${emojis[0]}${RESET}"
    
    # 프로세스가 실행 중인 동안 이모지 애니메이션
    while ps -p $pid &>/dev/null; do
        sleep 0.2
        # 현재 이모지 지우기
        echo -ne "\b \b"  # 백스페이스, 공백, 다시 백스페이스
        # 다음 이모지 출력
        i=$(( (i+1) % ${#emojis[@]} ))
        echo -ne "${YELLOW}${emojis[$i]}${RESET}"
    done
    
    # 마지막 이모지 지우기
    echo -ne "\b \b"
    # 성공 마크 출력
    echo -e "${GREEN}✅${RESET}"
}

# 프로그레스 바 함수
show_progress_bar() {
    local pid=$1
    local title=$2
    local duration=$3  # 예상 소요 시간(초)
    local bar_size=40
    local char_done="█"
    local char_todo="░"
    
    echo -ne "${CYAN}$title ${RESET}"
    
    local start_time=$(date +%s)
    local elapsed=0
    local progress=0
    
    while ps -p $pid &>/dev/null; do
        elapsed=$(($(date +%s) - start_time))
        progress=$(( (elapsed * bar_size) / duration ))
        
        if [ $progress -gt $bar_size ]; then
            progress=$bar_size
        fi
        
        # 프로그레스 바 그리기
        echo -ne "["
        local i=0
        for ((i=0; i<$progress; i++)); do
            echo -ne "${GREEN}$char_done${RESET}"
        done
        
        for ((i=$progress; i<$bar_size; i++)); do
            echo -ne "${YELLOW}$char_todo${RESET}"
        done
        
        echo -ne "] ${BOLD}$(( (progress * 100) / bar_size ))%%${RESET}"
        
        sleep 0.2
        
        if [ $progress -lt $bar_size ]; then
            # 전체 프로그레스 바 지우기
            echo -ne "\r${CYAN}$title ${RESET}"
        fi
    done
    
    if [ $progress -lt $bar_size ]; then
        progress=$bar_size
        echo -ne "["
        for ((i=0; i<$bar_size; i++)); do
            echo -ne "${GREEN}$char_done${RESET}"
        done
        echo -ne "] ${BOLD}100%%${RESET}"
    fi
    
    echo -e " ${GREEN}✅${RESET}"
}

# 애니메이션 실행 함수
run_with_animation() {
    local cmd="$1"
    local title="$2"
    local duration="$3"  # 예상 소요 시간(초), progress_bar에만 사용
    
    # 명령 출력을 /dev/null로 리다이렉션
    eval "$cmd > /dev/null 2>&1" &
    local pid=$!
    
    case $ANIMATION_TYPE in
        spinner)
            show_spinner $pid
            ;;
        emoji)
            show_emoji_loading $pid "$title"
            ;;
        progress)
            show_progress_bar $pid "$title" $duration
            ;;
        *)
            wait $pid  # 애니메이션 없이 실행
            ;;
    esac
    
    # 명령어 실행 결과 확인
    wait $pid
    local exit_status=$?
    
    if [ $exit_status -ne 0 ]; then
        echo -e "${RED}❌ 오류: $title 실패${RESET}"
        return $exit_status
    fi
    
    return 0
}

# 로그 메시지 출력 함수
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

# 설정 함수
set_animation_type() {
    if [[ "$1" == "spinner" || "$1" == "emoji" || "$1" == "progress" || "$1" == "none" ]]; then
        ANIMATION_TYPE="$1"
        log_info "애니메이션 유형이 '$ANIMATION_TYPE'으로 설정되었습니다."
    else
        log_warning "지원되지 않는 애니메이션 유형입니다. 기본값 'emoji'를 사용합니다."
        ANIMATION_TYPE="emoji"
    fi
}

# 사용 예시:
# source "$(dirname "$0")/utils.sh"
# set_animation_type "emoji"
# run_with_animation "sleep 5" "패키지 설치 중" 5