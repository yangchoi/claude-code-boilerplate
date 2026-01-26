# [Project Name] Airflow DAGs

Airflow 데이터 파이프라인.

## Commands

```bash
# 로컬 테스트 (필수!)
./scripts/test_local.sh quick    # 문법 테스트
./scripts/test_local.sh          # 전체 테스트
./scripts/test_local.sh docker   # DAG 파싱 테스트

# 코드 품질
black .
pylint dags/ plugins/
```

## Project Structure

```
dags/
├── __init__.py
└── example_dag.py

plugins/
└── custom_plugin.py

tests/
└── test_dags/
    └── test_dag_integrity.py
```

## DAG Patterns

```python
from airflow.sdk import dag, task
from datetime import datetime

@dag(
    schedule="@daily",
    start_date=datetime(2024, 1, 1),
    catchup=False,
    max_active_runs=1,  # 순차 실행
    default_args={
        "retries": 1,
        "retry_delay": timedelta(minutes=5),
    }
)
def my_dag():
    @task
    def extract() -> list:  # -> dict는 multiple_outputs=True로 해석됨
        return [1, 2, 3]

    @task
    def transform(data: list) -> list:
        return [x * 2 for x in data]

    transform(extract())

my_dag()
```

## Gotchas

- `Variable.get()` 모듈 레벨 호출 금지 (task 내부에서만)
- DataFrame 반환 시 NaN → None 변환 필수
- `-> dict` 리턴 타입 힌트는 `multiple_outputs=True` 의미
- 순차 실행: `max_active_runs=1` 또는 `max_active_tis_per_dag=1`

## Checklist

### DAG 배포 전
1. `./scripts/test_local.sh quick` 실행
2. 기존 DAG와 이름 충돌 확인
3. retry/timeout 설정 확인
