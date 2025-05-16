# LazySet

이 저장소는 Neovim, LazyVim 및 필요한 개발 도구를 자동으로 설치하는 스크립트를 제공합니다.

## 저장소 구조

```
.
├── bin/                    # 설치 스크립트
│   ├── install_neovim.sh   # Neovim 설치
│   ├── install_packages.sh # 필요한 패키지 설치
│   ├── install_nvm.sh      # NVM(Node Version Manager) 설치
│   └── install_lazyvim.sh  # LazyVim 설치
├── conf/                   # Neovim 설정 파일
│   └── lsp.lua             # LSP 설정 예시
├── install.sh              # 메인 설치 스크립트
└── README.md               # 문서
```

## 지원되는 환경

- Linux (Ubuntu, Debian, Fedora, Arch Linux)
- macOS (Intel, Apple Silicon)

## 설치 방법

### 원격 설치
```bash
curl -fsSL https://raw.githubusercontent.com/juseok1729/LazySet/main/remote_install.sh | bash
```

### 직접 설치
Git 저장소를 클론한 후 설치 스크립트를 실행합니다:

```bash
git clone https://github.com/juseok1729/LazySet.git
cd LazySet
chmod +x install.sh
./install.sh
```

## 개별 구성 요소 설치

필요한 경우 개별 구성 요소만 설치할 수 있습니다:

1. Neovim 설치:
   ```bash
   ./bin/install_neovim.sh [linux|macos] [x86_64|arm64]
   ```

2. 필요한 패키지 설치:
   ```bash
   ./bin/install_packages.sh [linux|macos]
   ```

3. NVM(Node Version Manager) 설치:
   ```bash
   ./bin/install_nvm.sh
   ```

4. LazyVim 설치:
   ```bash
   ./bin/install_lazyvim.sh [conf_dir_path]
   ```

## 설치되는 도구

- **Neovim**: 최신 버전의 Neovim 에디터
- **개발 도구**: ripgrep, fzf, fd, git
- **NVM**: Node.js 버전 관리자 (최신 LTS Node.js 버전 자동 설치)
- **LazyVim**: Neovim 구성 프레임워크

## 사용자 정의 설정

`conf` 디렉토리에 Neovim 설정 파일을 추가할 수 있습니다. 설치 시 이러한 파일들이 `~/.config/nvim/lua/plugins/` 디렉토리에 자동으로 복사됩니다.

예시 파일:
- `lsp.lua`: 언어 서버 프로토콜(LSP) 설정

추가 설정 파일을 생성하려면 `.lua` 확장자를 가진 파일을 `conf` 디렉토리에 추가하세요.

## 문제 해결

설치 후 `nvim` 명령이 작동하지 않는 경우:

```bash
# Linux의 경우
source ~/.bashrc

# macOS의 경우
source ~/.zshrc  # 또는 ~/.bashrc
```

## 커스터마이징

기본 설치 후 LazyVim 구성을 추가로 커스터마이징하려면 `~/.config/nvim` 디렉토리의 파일을 편집하세요.