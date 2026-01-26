# [Project Name] Backend

NestJS 백엔드 API.

## Commands

```bash
yarn start:dev    # 개발 (watch)
yarn build        # 빌드
yarn lint         # 린트
yarn test         # 테스트

# 로컬 테스트
./scripts/test_local.sh quick   # 린트만
./scripts/test_local.sh build   # 빌드만
./scripts/test_local.sh         # 전체 (lint + build + test)
```

## Architecture

```
src/
├── modules/      # Feature modules
│   └── user/
│       ├── user.module.ts
│       ├── user.controller.ts
│       ├── user.service.ts
│       └── entities/
├── common/       # Shared utilities
├── config/       # Configuration
└── main.ts       # Entry point
```

## Patterns

```typescript
// Controller에 비즈니스 로직 금지
@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get()
  findAll() {
    return this.userService.findAll(); // Service에 위임
  }
}

// TypeORM Entity - schema 지정
@Entity({ schema: 'public', name: 'users' })
export class User {}
```

## Gotchas

- Controller에 비즈니스 로직 금지 → Service로 분리
- Auth decorator 누락 주의
- TypeORM Entity에 `schema` 지정 권장
- DTO validation (`class-validator`) 필수
