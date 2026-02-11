# Project Guidelines

공통 가이드라인. 하위 프로젝트에서 상속.

## 코딩 원칙

**1. Think Before Coding**
- 가정을 명시적으로 밝히고, 불확실하면 질문
- 여러 해석이 가능하면 제시 (임의로 선택 금지)

**2. Simplicity First**
- 요청한 것만 구현, 추측성 기능/추상화 금지
- 200줄이 50줄로 가능하면 다시 작성

**3. Surgical Changes**
- 요청과 직접 관련된 코드만 수정
- 인접 코드 "개선", 포매팅 변경 금지
- 기존 스타일 유지 (다르게 하고 싶어도)

**4. Goal-Driven Execution**
- 작업을 검증 가능한 목표로 변환
- "버그 수정" → "재현 테스트 작성 → 통과시키기"

---

## 필수 규칙

- **커밋 금지 파일**: `~/.claude/`, `CLAUDE.local.md`, Personal Skills
- **Co-Authored-By 금지**: 커밋 메시지에 포함하지 않음
- **Claude Code 시그니처 금지**: PR 본문에 포함하지 않음
- **Assignee**: `[your-github-id]`
- **이슈 생성 시 라벨**: 이슈 만들기 전에 반드시 사용자에게 라벨 선택 확인
- **[custom]**: 이슈/PR 생성 시 팀별 규칙 추가

---

## Database 환경 [business info]

| 환경 | Host | 용도 |
|------|------|------|
| **Production** | `[prod-host]` | 운영 (주의!) |
| **Staging** | `[staging-host]` | 개발/테스트 (기본) |

**기본 규칙**: 특별한 언급 없으면 Staging DB 사용. 데이터 수정 전 반드시 Host 확인.

---

## 프로젝트별 정보 [business info]

| 프로젝트 | 라벨 | 테스트 | 특이사항 |
|----------|------|--------|----------|
| project-a | `area:frontend` | `./scripts/test_local.sh` | Next.js |
| project-b | `area:backend` | `./scripts/test_local.sh` | NestJS |

---

## Workflow Patterns

### Plan Mode (복잡한 작업)

```
1. Explore (Plan Mode)
   - 관련 파일 읽기, 기존 패턴 파악
   - "read /src/auth and understand how we handle sessions"

2. Plan (Plan Mode)
   - 구현 계획 수립
   - "What files need to change? Create a plan."

3. Implement (Normal Mode)
   - 계획대로 코드 작성, 테스트
   - "implement the plan. run tests and fix failures."

4. Commit
   - "commit with a descriptive message"
```

**Plan Mode 사용 기준:**
- 여러 파일 수정 필요
- 접근 방식이 불확실
- 새로운 기능 추가

**Plan Mode 불필요:**
- 단순 버그 수정
- 한 줄 변경
- 명확한 작업

### Claude Interview (큰 기능)

요구사항이 복잡할 때:

```
I want to build [간단한 설명]. Interview me using AskUserQuestion.

Ask about:
- 기술적 구현 방식
- UI/UX 요구사항
- 엣지 케이스
- 트레이드오프

Keep interviewing until we've covered everything, then write a spec.
```

### Parallel Sessions

**Writer/Reviewer 분리:**
```
Session A (Writer): "Implement rate limiter for API"
Session B (Reviewer): "Review the rate limiter in @src/middleware/rateLimiter.ts"
Session A: "Address this feedback: [Session B output]"
```

**Test-First:**
```
Session A: "Write tests for user authentication"
Session B: "Write code to pass these tests"
```

### Git Worktree 병렬 작업

여러 브랜치에서 동시 작업할 때:

```bash
# 세팅
git worktree add ../project-wt -b _worktree-temp

# 작업 (worktree 진입 후 반드시 feature 브랜치 생성)
cd ../project-wt
git checkout -b feature/actual-work  # 이 브랜치만 push

# 정리
git worktree remove ../project-wt
```

**주의**: `_worktree-*` 브랜치는 진입용일 뿐, 절대 push 금지

---

## Subagents

```
# 일반 코드 리뷰
"use subagent code-reviewer to review this code"

# NestJS 백엔드 리뷰
"use subagent nestjs-reviewer to review this code"

# Frontend 리뷰 (React/Next.js)
"use subagent frontend-reviewer to review this code"

# Airflow DAG 리뷰
"use subagent dag-reviewer to review this DAG"

# 테스트 작성
"use subagent test-writer to write tests for this"

# 조사/탐색 (컨텍스트 절약)
"use subagent to investigate how authentication works"
```

---

## Headless Mode (CI/자동화)

```bash
# 단순 쿼리
claude -p "Explain what this project does"

# JSON 출력
claude -p "List all API endpoints" --output-format json

# 스트리밍
claude -p "Analyze this log file" --output-format stream-json

# 배치 작업
for file in $(cat files.txt); do
  claude -p "Migrate $file from React to Vue" --allowedTools "Edit,Bash(git commit:*)"
done
```

---

## Context Management

### /clear 사용 시점
- 관련 없는 새 작업 시작할 때
- 같은 문제 2번 이상 수정 실패 시
- 컨텍스트가 너무 길어졌을 때

### /compact 지침

```
When compacting, preserve:
- 수정된 파일 경로 전체 목록
- 테스트 명령어와 결과
- 발생한 에러 메시지
- 환경 정보 (Prod/Dev)
- 현재 작업 중인 브랜치
```

### Session Resume

```bash
claude --continue    # 최근 세션 재개
claude --resume      # 세션 선택
```

세션 이름 지정: `/rename oauth-migration`

---

## 작업 전 확인

### 코드 변경 시
1. 기존 패턴 확인 (같은 프로젝트 내 유사 코드 참고)
2. 테스트 가능 여부 확인
3. 배포 전 로컬 검증: `./scripts/test_local.sh`

### 데이터 변경 시
1. 현재 데이터 상태 조회
2. 영향 범위 파악
3. 백업 필요 여부

---

## 코드 작성 후 자동 리뷰

코드 변경 작업 완료 시 `code-reviewer` 서브에이전트로 자동 리뷰 실행:
- 대상: 새 기능 구현, 버그 수정, 리팩토링 등 코드 변경 작업
- 제외: 단순 설정 변경, 문서 수정, 한 줄 수정
- 리뷰 관점: Kent Beck Simple Design, Over-engineering 방지

---

## 도메인별 가이드 (Skills) [custom]

- `[skill-name]` - [description]
- `[skill-name]` - [description]
