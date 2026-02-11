#!/bin/bash
# Auto-lint hook
# Edit/Write 후 ts/js/tsx/jsx 파일이면 자동으로 eslint --fix 실행

# stdin에서 JSON input 읽기
INPUT=$(cat)

# 파일 경로 추출
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')

# 파일 경로가 없으면 종료
if [ -z "$FILE_PATH" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# ts/js/tsx/jsx 파일인지 확인
if [[ "$FILE_PATH" =~ \.(ts|js|tsx|jsx)$ ]]; then
  # 파일이 존재하는지 확인
  if [ -f "$FILE_PATH" ]; then
    # 프로젝트 루트 찾기 (package.json이 있는 디렉토리)
    DIR=$(dirname "$FILE_PATH")
    while [ "$DIR" != "/" ]; do
      if [ -f "$DIR/package.json" ]; then
        # eslint가 있는지 확인
        if [ -f "$DIR/node_modules/.bin/eslint" ]; then
          # eslint --fix 실행 (에러 무시)
          cd "$DIR" && ./node_modules/.bin/eslint --fix "$FILE_PATH" 2>/dev/null
          if [ $? -eq 0 ]; then
            echo "INFO: Auto-linted $FILE_PATH" >&2
          fi
        fi
        break
      fi
      DIR=$(dirname "$DIR")
    done
  fi
fi

# 항상 성공 반환
echo '{"decision": "allow"}'
