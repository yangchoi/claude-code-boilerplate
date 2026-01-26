#!/bin/bash
# Hook: Frontend 파일 수정 시 빌드 알림
# PostToolUse hook - stdin으로 JSON 전달됨

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')

# 설정: 프로젝트 경로 패턴 (수정 필요)
FRONTEND_PATTERNS=("frontend" "web" "app")

# Frontend 파일인지 확인
is_frontend=false
for pattern in "${FRONTEND_PATTERNS[@]}"; do
    if [[ "$FILE_PATH" == *"/$pattern/"* ]]; then
        is_frontend=true
        break
    fi
done

if $is_frontend; then
    if [[ "$FILE_PATH" == *.tsx ]] || [[ "$FILE_PATH" == *.ts ]] || [[ "$FILE_PATH" == *.jsx ]]; then
        echo "[Hook] Frontend 파일 수정됨: $(basename "$FILE_PATH")"
        echo "[Hook] 빌드 확인 권장: ./scripts/test_local.sh build"
    fi
fi
