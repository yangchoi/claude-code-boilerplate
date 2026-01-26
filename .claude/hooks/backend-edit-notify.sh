#!/bin/bash
# Hook: Backend 파일 수정 시 테스트 알림
# PostToolUse hook - stdin으로 JSON 전달됨

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')

# 설정: 프로젝트 경로 패턴 (수정 필요)
BACKEND_PATTERNS=("backend" "api" "server")

# Backend 파일인지 확인
is_backend=false
for pattern in "${BACKEND_PATTERNS[@]}"; do
    if [[ "$FILE_PATH" == *"/$pattern/"* ]]; then
        is_backend=true
        break
    fi
done

if $is_backend; then
    if [[ "$FILE_PATH" == *.ts ]] && [[ "$FILE_PATH" != *.spec.ts ]] && [[ "$FILE_PATH" != *.test.ts ]]; then
        echo "[Hook] Backend 파일 수정됨: $(basename "$FILE_PATH")"
        echo "[Hook] 테스트 권장: ./scripts/test_local.sh quick"
    fi
fi
