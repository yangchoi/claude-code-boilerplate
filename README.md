# Claude Code Boilerplate

Claude Code 프로젝트 설정 보일러플레이트. [Best Practices](https://code.claude.com/docs/en/best-practices) 기반.

## Quick Start

```bash
# 프로젝트 루트로 복사
cp -r .claude /your/project/
cp CLAUDE.md /your/project/

# 스크립트 권한 부여
chmod +x /your/project/.claude/hooks/*.sh
```

## Structure

```
.claude/
├── agents/           # Subagents
│   ├── code-reviewer.md
│   ├── test-writer.md
│   ├── nestjs-reviewer.md
│   ├── frontend-reviewer.md
│   └── dag-reviewer.md
├── hooks/            # PostToolUse hooks
│   ├── backend-edit-notify.sh
│   ├── frontend-edit-notify.sh
│   └── python-edit-notify.sh
└── settings.local.json.example

templates/            # Project-specific CLAUDE.md templates
├── CLAUDE-frontend.md
├── CLAUDE-backend.md
├── CLAUDE-airflow.md
└── test_local.sh

skills/               # Custom skill examples
└── example-skill.md

CLAUDE.md             # Root/shared guidelines
```

## Features

### 1. CLAUDE.md

프로젝트별 컨텍스트 파일. Claude가 자동으로 읽음.

```markdown
# Project Name

간단한 설명.

## Commands
빌드/테스트 명령어

## Architecture
핵심 구조

## Gotchas
주의사항
```

### 2. Subagents

코드 리뷰, 테스트 작성 등을 위임:

```
"use subagent code-reviewer to review this code"
"use subagent test-writer to write tests for this function"
```

### 3. Hooks

파일 수정 시 자동 알림:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/hook.sh"
          }
        ]
      }
    ]
  }
}
```

### 4. Workflow Patterns

**Plan Mode** - 복잡한 작업 전 계획 수립:
1. Explore (read files, understand patterns)
2. Plan (create implementation plan)
3. Implement (write code)
4. Test & Commit

**Claude Interview** - 요구사항 정의:
```
I want to build [feature]. Interview me using AskUserQuestion.
```

**Parallel Sessions**:
- Session A: Writer
- Session B: Reviewer

## Customization

1. `settings.local.json.example`을 `settings.local.json`으로 복사
2. 프로젝트 경로에 맞게 hook 경로 수정
3. 필요 없는 subagent 삭제

## License

MIT
