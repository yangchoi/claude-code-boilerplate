#!/bin/bash
# 위험한 명령어 차단 hook
# Claude Code가 Bash 명령 실행 전에 호출됨

# stdin에서 JSON input 읽기
INPUT=$(cat)

# 명령어 추출
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# 위험한 패턴 목록
DANGEROUS_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \*"
  "DROP TABLE"
  "DROP DATABASE"
  "DELETE FROM.*WHERE 1=1"
  "TRUNCATE TABLE"
  "git push.*--force.*main"
  "git push.*--force.*master"
  "git reset --hard.*origin"
  "> /dev/sda"
  "mkfs\."
  "dd if=.*/dev/"
)

# 패턴 체크
for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    # STDERR로 경고 메시지 출력 (사용자에게 표시됨)
    echo "WARN: 위험한 명령어 감지: $pattern" >&2

    # JSON 응답으로 차단
    echo '{"decision": "block", "reason": "위험한 명령어가 감지되었습니다: '"$pattern"'"}'
    exit 0
  fi
done

# [custom] Production 환경 접근 경고 (차단은 아님)
# 아래 패턴을 자신의 환경에 맞게 수정하세요
# if echo "$COMMAND" | grep -qE "your-prod-db-host|your-prod-cluster"; then
#   echo "WARN: Production 환경 접근 감지됨" >&2
# fi

# 통과
echo '{"decision": "allow"}'
