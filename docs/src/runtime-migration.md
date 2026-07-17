# Runtime Migration

This document is the durable handoff record for moving Pinry from its
unsupported Python and Django stack to a supported runtime. Update it whenever
a checkpoint starts or completes so the work can resume without relying on a
chat session.

## Target

- Python 3.12
- Django 5.2 LTS
- A Pillow release that fixes the remaining image-parser advisories
- A Gunicorn release that fixes the request-smuggling advisories
- Reproducible Poetry lock and requirements exports
- Passing unit, integration, lint, migration, audit, production-build, HTTP,
  and persistence checks

## Current State

Last updated: 2026-07-17

Baseline commit: `3ba6a24` (`build: update Python 3.9 image dependencies`)

- Python is constrained to `>=3.12,<3.13` and resolves to 3.12.13 in the
  production image.
- Django is 5.2.16 LTS; DRF is 3.17.1, django-filter is 25.2, and the
  API schema uses drf-spectacular 0.30.0.
- Pillow is 12.3.0, Requests is 2.34.2, and urllib3 is 2.7.0.
- Gunicorn is 26.0.0.
- The Python 3.12 container suite passes 50 tests and configured flake8.
- The production image builds and its persistence/HTTP smoke checks pass.
- The dependency audit reports no known vulnerabilities.

## Checkpoints

| Checkpoint | Status | Result |
| --- | --- | --- |
| 0. Record baseline and migration process | Complete | Migration ledger added |
| 1. Upgrade Gunicorn on Python 3.9 | Complete | 23.0.0; 49 tests; audit reduced from 43 to 38 findings |
| 2. Inventory and resolve Django 2.2 deprecations | Complete | Pinry-owned deprecation warnings removed |
| 3. Bridge Django 2.2 to 3.2 | Complete | 3.2.25; 49 tests; production persistence smoke passed |
| 4. Bridge Django 3.2 to 4.2 | Complete | 4.2.30; 50 tests; schema migration and persistence smoke passed |
| 5. Upgrade Python 3.9 to 3.12 | Complete | 3.12.13; 50 tests; production persistence smoke passed |
| 6. Upgrade Django 4.2 to 5.0 | Complete | 5.0.14; 50 tests; optional database drivers and persistence smoke passed |
| 7. Upgrade Django 5.0 to 5.1 | Complete | 5.1.15; fresh and existing database paths passed |
| 8. Upgrade Django 5.1 to 5.2 LTS | Complete | 5.2.16 LTS; 50 tests; production persistence smoke passed |
| 9. Upgrade Pillow and finish the audit | Complete | Pillow 12.3.0; Requests 2.34.2; zero audit findings |
| 10. Run final production and persistence verification | Complete | Default image, HTTP, drivers, thumbnail, data, and PID 1 exit passed |

Intermediate Django releases are migration checkpoints only. They are not
deployment targets because Django 3.2, 4.2, 5.0, and 5.1 are no longer
supported.

## Verification Gate

Run the applicable parts of this gate at every checkpoint and record any
exceptions below:

```console
./docker/poetry_podman.sh check
./docker/test_podman.sh test
./docker/test_podman.sh test --parallel
./docker/test_podman.sh check
./docker/test_podman.sh makemigrations --check --dry-run
./docker/test_podman.sh -- flake8 .
./docker/audit_podman.sh
./docker/build_podman.sh localhost/pinry:migration
```

The duplicate serial and parallel test commands are intentional while changing
framework/runtime versions. The production smoke also verifies installed
versions, HTTP 200 responses for `/`, `/register/`, and `/admin/login/`, and
that a board stored in `/data` survives a container replacement.

## Resume Procedure

1. Read this file and `docs/src/dependency-audit.md`.
2. Run `git status --short --branch` and inspect uncommitted changes rather
   than discarding them.
3. Find the first checkpoint that is not complete.
4. Confirm the last completed checkpoint still passes its recorded gate.
5. Continue with the next incremental dependency release; do not skip bridge
   releases merely because the resolver accepts a larger jump.

## Work Log

### 2026-07-17: Baseline

- Confirmed the worktree is clean at `3ba6a24`.
- Confirmed `origin/master` points at the same commit.
- Selected Python 3.12 and Django 5.2 LTS as the supported endpoint.
- Kept Gunicorn as the first isolated security update before framework work.

### 2026-07-17: Gunicorn 23.0.0

- Selected 23.0.0 as the newest release compatible with Python 3.9. Gunicorn
  24.0.0 and newer require Python 3.10 or newer.
- Regenerated `poetry.lock`, `requirements.txt`, and `requirements-dev.txt`.
- Passed 49 serial tests, 49 parallel tests, flake8, Django system checks,
  migration drift checks, and `poetry check`.
- Built `localhost/pinry:gunicorn` and confirmed Gunicorn 23.0.0 starts.
- Confirmed HTTP 200 for `/`, `/register/`, and `/admin/login/`.
- Confirmed the persisted `Podman smoke board` remained in `/data`.
- Audit improved from 43 findings in 13 packages to 38 findings in 11
  packages. Both Gunicorn advisories and the three setuptools findings were
  removed; Gunicorn 23 no longer installs setuptools at runtime.
- The existing shutdown issue remains: `start.sh` does not forward SIGTERM,
  so Podman escalates to SIGKILL after the stop timeout.

### 2026-07-17: Django 2.2 Deprecation Inventory

- `python -Wa manage.py test` still passed all 49 tests.
- Pinry-owned warnings: four `filter_fields` attributes, one
  `ugettext_lazy` import, and one `assertEquals` call.
- Third-party warning: CoreAPI imports the deprecated `pkg_resources` API.
- Existing schema-generation warnings come from django-filter and are expected
  to be reassessed with the REST framework dependency upgrades.

### 2026-07-17: Django 3.2.25 Bridge

- Django 3.2.25 resolved successfully with the existing Python 3.9 dependency
  set and passed all 49 tests.
- Set `DEFAULT_AUTO_FIELD` to `django.db.models.AutoField` to preserve the
  existing primary-key schema.
- Replaced the deprecated `django.conf.urls.url()` calls with `path()`.
- Remaining deprecation warnings belong to CoreAPI (`pkg_resources`) and the
  old django-taggit release (`default_app_config`).
- Passed flake8 and migration drift checks, built the production image, and
  confirmed the three HTTP endpoints and persisted board on Django 3.2.25.
- Audit improved from 38 to 37 findings by removing the Django reflected-file
  download advisory fixed after the 2.2 line.

### 2026-07-17: Django 4.2.30 Bridge

- Selected DRF 3.16.1, django-filter 25.1, and django-taggit 6.1.0 as the
  newest releases in their lines that support both Django 4.2 and Python 3.9.
- DRF 3.16 rejects duplicate router basenames. Renamed the board autocomplete
  basename to `board-autocomplete`; its URL path is unchanged.
- Removed the deprecated `USE_L10N` setting.
- Replaced `Board.Meta.index_together` with a named `models.Index`; a schema
  migration is required and must be verified against the persisted smoke data.
- Replaced the deprecated CoreAPI docs with drf-spectacular OpenAPI schema and
  Swagger UI endpoints. Sidecar assets keep `/api/v2/docs/` self-contained.
- Updated django-taggit's `.set()` calls to pass one iterable, and updated
  privacy assertions for DRF's consistent paginated response envelope.
- The production persistence smoke exposed that `start.sh` only migrated a new
  SQLite database. It now applies pending migrations on every start and fails
  startup if migration fails.
- Startup now replaces its shell processes with Gunicorn so the server receives
  container stop signals directly.
- Passed 50 serial tests, 50 parallel tests, flake8, system checks, migration
  drift checks, and `poetry check`. The warnings run only reports
  `index_together` while reconstructing historical migration states.
- Audit improved from 37 findings in 11 packages to 26 findings in 8 packages.
- Built `localhost/pinry:django42` and received HTTP 200 from `/`,
  `/register/`, `/admin/login/`, `/api/v2/docs/`, and the OpenAPI schema.
- Applied migration `0011` to the existing SQLite database, confirmed its named
  index, and preserved the `Podman smoke board` record.
- The smoke container stopped with exit code 0 rather than the previous 137.
  Podman 4.9's remote stop call still took about 25 seconds to return.

### 2026-07-17: Python 3.12 Runtime

- Started from checkpoint commit `c9c41e3`.
- Updated the production, test, audit, Poetry, legacy development, and CI
  runtimes together so no maintained path silently remains on Python 3.9.
- Consolidated the duplicated Poetry development dependency tables, moved
  static metadata to the standard `[project]` table, and replaced the obsolete
  `mock` backport with `unittest.mock`.
- Pillow remains at 11.3.0 for the later isolated image-library checkpoint.
- Django 4.2 requires the abandoned `cx-Oracle` driver, which cannot build on
  Python 3.12. The intermediate image retains MySQL support but temporarily
  omits Oracle; add the maintained `oracledb` driver once Django 5.x supports
  it in the next framework checkpoints.
- Regenerated the lock from constraints with Poetry 2.4.1 rather than retaining
  old compatible transitive pins. Updated Gunicorn to 26.0.0, Requests to
  2.33.0, urllib3 to 2.7.0, Markdown to 3.10.2, and psycopg2-binary to 2.9.12.
- Updated flake8, Black, MkDocs, Material for MkDocs, django-extensions, and
  qrcode to Python 3.12-compatible releases.
- Passed 50 serial tests, 50 parallel tests, warnings-visible tests, flake8,
  system checks, migration drift checks, `poetry check`, and strict MkDocs
  build. Only historical `index_together` migration-state warnings remain.
- Audit improved from 26 findings in 8 packages to 14 findings in Pillow only;
  pip-audit 2.10.1 reports `PYSEC-2026-165` twice.
- Built both `localhost/pinry:py312` and the legacy compose development image.
- Received HTTP 200 from all five smoke endpoints on Python 3.12.13, confirmed
  all migrations and the persisted board, and stopped with exit code 0.

### 2026-07-17: Django 5.0.14 Bridge

- Started from checkpoint commit `732893e`.
- Django 5.0 supports the maintained `oracledb` driver. The production image
  restores Oracle support with oracledb 4.0.2 and pins mysqlclient 2.2.8.
- The optional-driver smoke exposed that the final image copied mysqlclient
  without its MariaDB shared library. The final stage now installs
  `libmariadb3`.
- Passed 50 serial tests, 50 parallel tests, warnings-visible tests, flake8,
  system checks, migration drift checks, and `poetry check`. Only the known
  historical `index_together` migration-state warnings remain.
- Built `localhost/pinry:django50` and received HTTP 200 from all five smoke
  endpoints. Confirmed Django 5.0.14, oracledb 4.0.2, and mysqlclient 2.2.8
  import in the final image, preserved the existing board, and stopped with
  exit code 0.
- The audit reports 18 rows: four Django findings and 14 Pillow findings. This
  unsupported Django release is only a verified migration bridge; all four
  Django findings are fixed by the next 5.1.15 checkpoint.

### 2026-07-17: Django 5.1.15 Bridge

- Started from checkpoint commit `6835ac0`.
- This checkpoint must verify that Django 5.1 can still reconstruct the
  historical `index_together` operations while the runtime model continues to
  use its named `models.Index` replacement.
- A fresh-database test confirmed Django 5.1 retains the historical migration
  state but no longer creates its database index. Migration `0011` now removes
  that legacy index only when it exists, while applying the state transition
  separately before creating the named replacement.
- Passed 50 serial tests, 50 parallel tests, warnings-visible tests, flake8,
  system checks, migration drift checks, and `poetry check` without warnings.
- The audit is back to the 14 Pillow-only rows; all four Django 5.0 bridge
  findings are resolved.
- Built `localhost/pinry:django51` and received HTTP 200 from all five smoke
  endpoints. Confirmed both optional database drivers, preserved the existing
  board, and stopped with exit code 0.

### 2026-07-17: Django 5.2.16 LTS

- Started from checkpoint commit `f5f8d0a`.
- Updating Django to the current 5.2 LTS security release together with DRF
  3.17.1 and django-filter 25.2, whose current releases target Django 5.2.
- Passed 50 serial tests, 50 parallel tests, warnings-visible tests, flake8,
  system checks, migration drift checks, `poetry check`, and the strict MkDocs
  build. The warnings-visible run produced no deprecation warnings.
- The audit remains isolated to the 14 Pillow rows scheduled for checkpoint 9.
- Built `localhost/pinry:django52` and received HTTP 200 from all five smoke
  endpoints. Confirmed the framework, REST, filter, Oracle, and MySQL versions
  in the final image, preserved the existing board, and stopped with exit code
  0.

### 2026-07-17: Final Runtime Dependencies

- Started from checkpoint commit `9871f72`.
- PyPI identifies Pillow 12.3.0, Requests 2.34.2, and urllib3 2.7.0 as their
  current releases. Updating Pillow and Requests while retaining the already
  current urllib3 pin.
- Pinry already uses `Image.Resampling.LANCZOS`; no removed Pillow resampling
  constant remains in the Python source.
- Passed 50 serial tests, 50 parallel tests, warnings-visible tests, flake8,
  system checks, migration drift checks, `poetry check`, and the strict MkDocs
  build.
- `pip-audit 2.10.1` reports no known vulnerabilities in the locked runtime
  requirements.
- Built the default `localhost/pinry:latest` image and received HTTP 200 from
  all five smoke endpoints. Confirmed the target Python dependencies and both
  optional database drivers, verified no pending migrations, and preserved the
  existing board.
- Exercised Pillow in the production image by resizing, cropping, and encoding
  an in-memory image as a 24 by 24 PNG. The container's PID 1 stopped with exit
  code 0.
- Podman 4.9 still took about 25 seconds to return from the remote stop call
  and logged forced cleanup of a remaining container process. Track process
  supervision as a separate container-runtime cleanup; it does not change the
  verified application exit code or persisted data result.
