# Project Guidelines

공통 가이드라인. 하위 프로젝트에서 상속.

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
