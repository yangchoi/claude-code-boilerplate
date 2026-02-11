#!/bin/bash
# macOS 알림 hook
# Claude Code 작업 완료 시 알림 표시

# stdin에서 JSON input 읽기
INPUT=$(cat)

# 메시지 추출
MESSAGE=$(echo "$INPUT" | jq -r '.message // "작업 완료"')
TITLE=$(echo "$INPUT" | jq -r '.title // "Claude Code"')

# macOS 알림 표시
osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"Glass\""

# 항상 성공 반환
echo '{"decision": "allow"}'
