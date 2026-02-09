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

**템플릿 태그:**
- `[business info]` - 회사/프로젝트별 정보 (DB 호스트, 프로젝트 목록 등)
- `[custom]` - 팀별 커스텀 규칙

```markdown
# Project Name

간단한 설명.

## 코딩 원칙
Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven

## 필수 규칙
커밋 금지 파일, Assignee 등

## Database 환경 [business info]
Production/Staging 호스트

## 프로젝트별 정보 [business info]
프로젝트 테이블

## Commands
빌드/테스트 명령어

## 도메인별 Skills [custom]
팀별 스킬 목록
```

### 2. 코딩 원칙

CLAUDE.md에 포함된 핵심 원칙:

1. **Think Before Coding** - 가정 명시, 불확실하면 질문
2. **Simplicity First** - 요청한 것만 구현, 추측성 기능 금지
3. **Surgical Changes** - 관련 코드만 수정, 인접 코드 "개선" 금지
4. **Goal-Driven Execution** - 작업을 검증 가능한 목표로 변환

### 3. Subagents

코드 리뷰, 테스트 작성 등을 위임:

```
"use subagent code-reviewer to review this code"
"use subagent test-writer to write tests for this function"
```

### 4. Hooks

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

### 5. Workflow Patterns

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

**Git Worktree** - 여러 브랜치 동시 작업:
```bash
git worktree add ../project-wt -b _worktree-temp
cd ../project-wt
git checkout -b feature/actual-work  # 이 브랜치만 push
```

## Customization

1. `settings.local.json.example`을 `settings.local.json`으로 복사
2. 프로젝트 경로에 맞게 hook 경로 수정
3. 필요 없는 subagent 삭제
4. `[business info]`, `[custom]` 태그 부분을 팀에 맞게 수정

## License

MIT
