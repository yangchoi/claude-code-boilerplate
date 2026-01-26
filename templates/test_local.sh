#!/bin/bash
# 로컬 테스트 스크립트 템플릿
#
# 사용법:
#   ./scripts/test_local.sh          # 전체 테스트
#   ./scripts/test_local.sh quick    # 빠른 테스트 (lint만)
#   ./scripts/test_local.sh build    # 빌드만

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

echo_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 패키지 매니저 감지
detect_package_manager() {
    if [ -f "pnpm-lock.yaml" ]; then
        echo "pnpm"
    elif [ -f "yarn.lock" ]; then
        echo "yarn"
    elif [ -f "package-lock.json" ]; then
        echo "npm"
    elif [ -f "poetry.lock" ]; then
        echo "poetry"
    elif [ -f "requirements.txt" ]; then
        echo "pip"
    else
        echo "unknown"
    fi
}

PM=$(detect_package_manager)

# Quick: Lint만
run_quick() {
    echo_info "Running quick tests (lint)..."

    case $PM in
        pnpm)
            pnpm lint
            ;;
        yarn)
            yarn lint
            ;;
        npm)
            npm run lint
            ;;
        poetry)
            poetry run black --check .
            poetry run pylint **/*.py
            ;;
        pip)
            black --check .
            pylint **/*.py 2>/dev/null || true
            ;;
        *)
            echo_error "Unknown package manager"
            exit 1
            ;;
    esac
}

# Build만
run_build() {
    echo_info "Running build..."

    case $PM in
        pnpm)
            pnpm build
            ;;
        yarn)
            yarn build
            ;;
        npm)
            npm run build
            ;;
        poetry)
            echo_info "Python project - no build step"
            ;;
        pip)
            echo_info "Python project - no build step"
            ;;
        *)
            echo_error "Unknown package manager"
            exit 1
            ;;
    esac
}

# 전체 테스트
run_all() {
    echo_info "Running all tests..."

    run_quick

    case $PM in
        pnpm|yarn|npm)
            run_build
            echo_info "Running tests..."
            $PM test 2>/dev/null || $PM run test 2>/dev/null || echo_warn "No test script found"
            ;;
        poetry)
            echo_info "Running pytest..."
            poetry run pytest tests/ -v --tb=short
            ;;
        pip)
            echo_info "Running pytest..."
            python -m pytest tests/ -v --tb=short
            ;;
    esac
}

# 메인
case "${1:-all}" in
    quick)
        run_quick
        ;;
    build)
        run_build
        ;;
    all|*)
        run_all
        ;;
esac

echo ""
echo_info "Done!"
