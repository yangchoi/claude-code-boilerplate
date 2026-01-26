# Example Skill

Skills는 자주 사용하는 명령어/가이드를 재사용 가능하게 만든 것.

## Skill 구조

```
~/.claude/skills/
└── skill-name/
    └── instructions.md
```

## 예시: git-commit-pr Skill

`~/.claude/skills/git-commit-pr/instructions.md`:

```markdown
# Git Commit & PR 가이드

## Commit 규칙
- feat: 새 기능
- fix: 버그 수정
- refactor: 리팩토링
- docs: 문서 변경
- test: 테스트 추가/수정
- chore: 기타 변경

## 커밋 메시지 형식
```
type(scope): 간단한 설명

상세 설명 (필요시)
```

## PR 규칙
- 제목은 커밋 메시지와 동일하게
- Description에 변경 사항 요약
- 관련 이슈 링크 (Closes #123)
```

## 예시: database-guide Skill

`~/.claude/skills/database-guide/instructions.md`:

```markdown
# Database 가이드

## 환경
| 환경 | Host | 용도 |
|------|------|------|
| Prod | xxx.xxx.xxx | 운영 |
| Dev  | yyy.yyy.yyy | 개발 |

## 접속 방법
```bash
psql -h $HOST -U $USER -d $DB
```

## 주의사항
- Prod 데이터 변경 전 백업 필수
- 대량 UPDATE/DELETE 시 트랜잭션 사용
```

## Skill 사용법

CLAUDE.md에서 참조:
```markdown
> 공통 가이드: `git-commit-pr`, `database-guide`
```

Claude가 자동으로 해당 skill 파일을 참조함.
