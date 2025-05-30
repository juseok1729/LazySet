# LazySet

이 저장소는 Neovim, LazyVim 및 기타 필요한 개발 도구를 자동으로 설치하기 위한 스크립트를 제공합니다.

## 목차

- [구조](#저장소-구조)
- [환경](#지원되는-환경)
- [설치 및 업데이트](#설치-및-업데이트)
   - [설치 스크립트](#설치--업데이트-스크립트)
   - [수동 설치](#수동-설치)
   - [개별 구성 요소 설치](#개별-구성-요소-설치)
   - [설치된 도구](#설치된-도구)
- [사용자 정의 구성](#사용자-정의-구성)
- [문제 해결](#문제-해결)
- [커스터마이징](#커스터마이징)

## 저장소 구조

```
.
├── README-KO.md               # 한국어 문서
├── README.md                  # 영어 문서
├── _install.sh                # 메인 설치 스크립트
├── bin/                       # 설치 스크립트 디렉토리
│   ├── install_lazyvim.sh     # LazyVim 설치 스크립트
│   ├── install_neovim.sh      # Neovim 설치 스크립트
│   ├── install_nvm.sh         # NVM (Node Version Manager) 설치 스크립트
│   ├── install_packages.sh    # 필수 패키지 설치 스크립트
│   └── utils.sh               # 스크립트용 유틸리티 함수
├── conf/                      # 설정 파일 디렉토리
│   ├── ghostty/               # Ghostty 터미널 설정
│   │   └── config             # Ghostty 설정 파일
│   ├── nvim/                  # Neovim 설정 파일들
│   │   ├── lazy-lock.json     # LazyVim 플러그인 잠금 파일
│   │   ├── lazyvim.json       # LazyVim 설정 파일
│   │   └── lua/               # Lua 설정 디렉토리
│   │       ├── config/        # 핵심 설정 파일들
│   │       │   ├── autocmds.lua    # 자동 명령 설정
│   │       │   ├── keymaps.lua     # 키 매핑 설정
│   │       │   ├── lazy.lua        # Lazy.nvim 플러그인 매니저 설정
│   │       │   └── options.lua     # Neovim 옵션 설정
│   │       └── plugins/       # 플러그인 설정들
│   │           └── colorscheme.lua # 컬러 스킴 설정
│   └── vivaldi/               # Vivaldi 브라우저 설정
│       └── Preferences        # Vivaldi 환경설정 파일
└── install.sh                 # 원격 설치 스크립트
```

## 지원되는 환경

- 리눅스 (Ubuntu, Debian, Fedora, Arch Linux)
- macOS (Intel, Apple Silicon)

## 설치 및 업데이트
### 설치 & 업데이트 스크립트

설치하는 가장 간단한 방법은 다음과 같은 단일 명령어입니다:

```bash
curl -fsSL https://raw.githubusercontent.com/juseok1729/LazySet/main/install.sh | bash
```

또는 wget을 사용하는 경우:

```bash
wget -O- https://raw.githubusercontent.com/juseok1729/LazySet/main/install.sh | bash
```

### 수동 설치

Git 저장소를 복제하고 설치 스크립트를 실행하세요:

```bash
git clone https://github.com/juseok1729/LazySet.git
cd LazySet
chmod +x _install.sh
./_install.sh
```

### 개별 구성 요소 설치

필요한 경우 개별 구성 요소를 설치할 수 있습니다:

1. Neovim 설치:
   ```bash
   ./bin/install_neovim.sh [linux|macos] [x86_64|arm64]
   ```

2. 필요한 패키지 설치:
   ```bash
   ./bin/install_packages.sh [linux|macos]
   ```

3. NVM (Node Version Manager) 설치:
   ```bash
   ./bin/install_nvm.sh
   ```

4. LazyVim 설치:
   ```bash
   ./bin/install_lazyvim.sh [conf_dir_path]
   ```

### 설치된 도구

- **Neovim**: Neovim 편집기의 최신 버전
- **개발 도구**: ripgrep, fzf, fd, git, gcc
- **NVM**: Node.js 버전 관리자 (최신 LTS Node.js 버전 자동 설치)
- **LazyVim**: Neovim 구성 프레임워크

## 사용자 정의 구성

`conf` 디렉토리에 Neovim 구성 파일을 추가할 수 있습니다. 설치 중에 이 파일들은 자동으로 `~/.config/nvim/lua/plugins/` 디렉토리에 복사됩니다.

예제 파일:
- `lsp.lua`: 언어 서버 프로토콜(LSP) 구성

추가 구성 파일을 만들려면 `conf` 디렉토리에 `.lua` 확장자를 가진 파일을 추가하세요. 파일이 없거나 디렉토리가 비어 있더라도 기본 LazyVim 설정으로 설치가 정상적으로 진행됩니다.

## 문제 해결

설치 후 `nvim` 명령이 작동하지 않는 경우:

```bash
# 리눅스의 경우
source ~/.bashrc

# macOS의 경우
source ~/.zshrc  # 또는 ~/.bashrc
```

macOS에서 Xcode 명령줄 도구를 설치해야 하는 경우 다음 명령으로 설치할 수 있습니다:

```bash
xcode-select --install
```

## 커스터마이징

기본 설치 후 LazyVim 구성을 추가로 사용자 정의하려면 `~/.config/nvim` 디렉토리의 파일을 편집하세요.