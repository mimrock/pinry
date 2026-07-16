# Dependency Audit

The runtime dependency lock can be audited from the repository root with:

    ./docker/audit_podman.sh

The audit runs in an isolated Python 3.9 container so the scanner's own
dependencies do not alter Pinry's locked environment.

## Baseline: 2026-07-16

The pre-upgrade `requirements.txt` was scanned with `pip-audit 2.8.0` and the
Python Packaging Advisory Database. It reported 58 known vulnerabilities in
12 packages:

```text
Name                Version     ID                  Fix Versions
------------------- ----------- ------------------- -------------------
certifi             2022.5.18.1 PYSEC-2022-42986    2022.12.7
certifi             2022.5.18.1 PYSEC-2023-135      2023.7.22
certifi             2022.5.18.1 PYSEC-2024-230      2024.7.4
django              2.2.28      PYSEC-2026-1297     4.2.16,5.0.9,5.1.1
django              2.2.28      GHSA-8x94-hmjh-97hq 3.2.15,4.0.7
django              2.2.28      GHSA-7xr5-9hcq-chf9 4.2.22,5.1.10,5.2.2
django              2.2.28      GHSA-6w2r-r2m5-xq5w 4.2.24,5.1.12,5.2.6
django              2.2.28      GHSA-qw25-v68c-qjf3 4.2.26,5.1.14,5.2.8
django              2.2.28      GHSA-frmv-pr5f-9mcr 4.2.26,5.1.14,5.2.8
djangorestframework 3.13.1      PYSEC-2026-1304     3.15.2
gunicorn            20.1.0      PYSEC-2026-1434     22.0.0
gunicorn            20.1.0      PYSEC-2026-1433     22.0.0
idna                3.3         PYSEC-2024-60       3.7
idna                3.3         PYSEC-2026-215      3.15
jinja2              3.1.2       PYSEC-2026-1473     3.1.3
jinja2              3.1.2       PYSEC-2026-1471     3.1.6
jinja2              3.1.2       PYSEC-2026-1474     3.1.4
jinja2              3.1.2       PYSEC-2026-1475     3.1.5
jinja2              3.1.2       PYSEC-2026-1472     3.1.5
markdown            3.1.1       PYSEC-2026-89
pillow              9.1.1       PYSEC-2022-42979    9.2.0
pillow              9.1.1       PYSEC-2023-175      10.0.1
pillow              9.1.1       PYSEC-2023-227      10.0.0
pillow              9.1.1       PYSEC-2026-165      12.2.0
pillow              9.1.1       PYSEC-2026-457      10.2.0
pillow              9.1.1       PYSEC-2026-1793     10.3.0
pillow              9.1.1       PYSEC-2026-1794     10.0.1
pillow              9.1.1       PYSEC-2026-2253     12.3.0
pillow              9.1.1       PYSEC-2026-2255     12.3.0
pillow              9.1.1       PYSEC-2026-2257     12.3.0
pillow              9.1.1       PYSEC-2026-2256     12.3.0
pillow              9.1.1       PYSEC-2026-2254     12.3.0
pillow              9.1.1       PYSEC-2026-2874     12.2.0
pillow              9.1.1       PYSEC-2026-3453     12.3.0
pillow              9.1.1       PYSEC-2026-3451     12.3.0
pillow              9.1.1       OSV-2022-715
pillow              9.1.1       OSV-2022-1074
requests            2.27.1      PYSEC-2023-74       2.31.0
requests            2.27.1      PYSEC-2026-1873     2.32.0
requests            2.27.1      PYSEC-2026-1872     2.32.4
requests            2.27.1      PYSEC-2026-2275     2.33.0
urllib3             1.22        PYSEC-2018-32       1.23
urllib3             1.22        PYSEC-2019-133      1.24.2
urllib3             1.22        PYSEC-2019-132      1.24.3
urllib3             1.22        PYSEC-2020-148      1.25.9
urllib3             1.22        PYSEC-2023-192      1.26.17,2.0.6
urllib3             1.22        PYSEC-2023-207      1.24.2
urllib3             1.22        PYSEC-2023-212      1.26.18,2.0.7
urllib3             1.22        PYSEC-2026-1999     2.5.0
urllib3             1.22        PYSEC-2026-1995     1.26.19,2.2.2
urllib3             1.22        PYSEC-2026-1994     2.6.0
urllib3             1.22        PYSEC-2026-1996     2.6.3
setuptools          68.0.0      PYSEC-2025-49       78.1.1
setuptools          68.0.0      PYSEC-2026-1918     70.0.0
setuptools          68.0.0      PYSEC-2026-3447     83.0.0
sqlparse            0.4.2       PYSEC-2023-87       0.4.4
sqlparse            0.4.2       PYSEC-2026-1940     0.5.0
sqlparse            0.4.2       GHSA-27jp-wm6q-gp25 0.5.4
```

## After Python 3.9 Dependency Upgrade: 2026-07-16

After upgrading Pillow, Requests, and urllib3, the same audit reported 43
known vulnerabilities in 13 packages. The additional package is `zipp`, which
is now correctly included by the regenerated Poetry export. The lock and both
requirements exports were inconsistent before regeneration.

```text
Name                Version     ID                  Fix Versions
------------------- ----------- ------------------- -------------------
certifi             2022.5.18.1 PYSEC-2022-42986    2022.12.7
certifi             2022.5.18.1 PYSEC-2023-135      2023.7.22
certifi             2022.5.18.1 PYSEC-2024-230      2024.7.4
django              2.2.28      PYSEC-2026-1297     4.2.16,5.0.9,5.1.1
django              2.2.28      GHSA-8x94-hmjh-97hq 3.2.15,4.0.7
django              2.2.28      GHSA-7xr5-9hcq-chf9 4.2.22,5.1.10,5.2.2
django              2.2.28      GHSA-6w2r-r2m5-xq5w 4.2.24,5.1.12,5.2.6
django              2.2.28      GHSA-qw25-v68c-qjf3 4.2.26,5.1.14,5.2.8
django              2.2.28      GHSA-frmv-pr5f-9mcr 4.2.26,5.1.14,5.2.8
djangorestframework 3.13.1      PYSEC-2026-1304     3.15.2
gunicorn            20.1.0      PYSEC-2026-1434     22.0.0
gunicorn            20.1.0      PYSEC-2026-1433     22.0.0
idna                3.3         PYSEC-2024-60       3.7
idna                3.3         PYSEC-2026-215      3.15
jinja2              3.0.3       PYSEC-2026-1473     3.1.3
jinja2              3.0.3       PYSEC-2026-1471     3.1.6
jinja2              3.0.3       PYSEC-2026-1474     3.1.4
jinja2              3.0.3       PYSEC-2026-1475     3.1.5
jinja2              3.0.3       PYSEC-2026-1472     3.1.5
markdown            3.4.4       PYSEC-2026-89
pillow              11.3.0      PYSEC-2026-165      12.2.0
pillow              11.3.0      PYSEC-2026-2250     12.2.0
pillow              11.3.0      PYSEC-2026-2253     12.3.0
pillow              11.3.0      PYSEC-2026-2251     12.2.0
pillow              11.3.0      PYSEC-2026-2255     12.3.0
pillow              11.3.0      PYSEC-2026-2257     12.3.0
pillow              11.3.0      PYSEC-2026-2256     12.3.0
pillow              11.3.0      PYSEC-2026-2254     12.3.0
pillow              11.3.0      PYSEC-2026-2252     12.2.0
pillow              11.3.0      PYSEC-2026-2249     12.1.1
pillow              11.3.0      PYSEC-2026-2874     12.2.0
pillow              11.3.0      PYSEC-2026-3453     12.3.0
pillow              11.3.0      PYSEC-2026-3451     12.3.0
requests            2.32.5      PYSEC-2026-2275     2.33.0
urllib3             2.6.3       PYSEC-2026-142      2.7.0
urllib3             2.6.3       PYSEC-2026-141      2.7.0
setuptools          68.0.0      PYSEC-2025-49       78.1.1
setuptools          68.0.0      PYSEC-2026-1918     70.0.0
setuptools          68.0.0      PYSEC-2026-3447     83.0.0
sqlparse            0.4.2       PYSEC-2023-87       0.4.4
sqlparse            0.4.2       PYSEC-2026-1940     0.5.0
sqlparse            0.4.2       GHSA-27jp-wm6q-gp25 0.5.4
zipp                3.8.0       PYSEC-2026-2074     3.19.1
```

The fixes listed for the remaining Pillow, Requests, and urllib3 advisories
require leaving the Python 3.9 dependency line. They are inputs to the planned
Python and Django migration rather than silently ignored audit failures.

## After Django 4.2 Bridge: 2026-07-17

Upgrading Django and the REST, filtering, tagging, and schema dependencies
reduced the result to 26 known vulnerabilities in 8 packages. In particular,
the Django and Django REST framework findings are no longer present.

```text
Name     Version     ID                  Fix Versions
-------- ----------- ------------------- ------------
certifi  2022.5.18.1 PYSEC-2022-42986    2022.12.7
certifi  2022.5.18.1 PYSEC-2023-135      2023.7.22
certifi  2022.5.18.1 PYSEC-2024-230      2024.7.4
idna     3.3         PYSEC-2024-60       3.7
idna     3.3         PYSEC-2026-215      3.15
markdown 3.4.4       PYSEC-2026-89
pillow   11.3.0      13 advisories        12.3.0 resolves all listed findings
requests 2.32.5      PYSEC-2026-2275     2.33.0
urllib3  2.6.3       PYSEC-2026-142      2.7.0
urllib3  2.6.3       PYSEC-2026-141      2.7.0
sqlparse 0.4.2       PYSEC-2023-87       0.4.4
sqlparse 0.4.2       PYSEC-2026-1940     0.5.0
sqlparse 0.4.2       GHSA-27jp-wm6q-gp25 0.5.4
zipp     3.8.0       PYSEC-2026-2074     3.19.1
```

The Pillow row is consolidated for readability; `pip-audit` reports each of
its 13 advisory identifiers separately. The final Python 3.12 dependency
refresh will verify every individual finding again.
