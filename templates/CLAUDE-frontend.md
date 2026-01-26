# [Project Name] Frontend

Next.js/React 프론트엔드 프로젝트.

## Commands

```bash
pnpm dev          # 개발 (turbopack)
pnpm build        # 빌드
pnpm lint         # ESLint
pnpm storybook    # Storybook (port 6006)

# 로컬 테스트
./scripts/test_local.sh quick   # 린트만
./scripts/test_local.sh build   # 빌드만
./scripts/test_local.sh         # 전체 (lint + build)
```

## Code Style

- TypeScript strict - `any` 지양
- Import: `@/` alias 사용
- Styling: TailwindCSS
- Server Components 우선

## Architecture

```
src/
├── app/          # App Router pages
├── components/   # React components
├── hooks/        # Custom hooks
├── lib/          # Utilities
└── types/        # TypeScript types
```

## Gotchas

- 'use client' 필요한 컴포넌트 확인
- next/image 사용 (img 태그 지양)
- Server Actions는 'use server' 필수
