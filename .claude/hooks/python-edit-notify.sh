#!/bin/bash
# Hook: Python 파일 수정 시 테스트 알림
# PostToolUse hook - stdin으로 JSON 전달됨

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')

# Python 파일인지 확인
if [[ "$FILE_PATH" == *.py ]]; then
    # 테스트 파일이 아닌 경우만
    if [[ "$FILE_PATH" != *"test_"* ]] && [[ "$FILE_PATH" != *"_test.py" ]]; then
        echo "[Hook] Python 파일 수정됨: $(basename "$FILE_PATH")"
        echo "[Hook] 테스트 권장: ./scripts/test_local.sh quick"
    fi
fi
