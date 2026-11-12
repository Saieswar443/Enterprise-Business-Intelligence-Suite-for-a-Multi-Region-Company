# Data Analytics Internship - Final Projects

| Project | Folder | Status |
|---|---|---|
| **DA-01** Enterprise Business Intelligence Suite for a Multi-Region Company | [`DA-01/`](DA-01/) | Code, tests, documentation, Power BI project and presentation in this repo |
| **DA-02** | `DA-02/` | *Replace this row when DA-02 is added* |

---

# DA-01 - Enterprise Business Intelligence Suite

One governed reporting system that combines **sales, finance (margin), supply chain, production and HR**, with **row-level security so each region manager sees only their own region**, refreshed nightly.
Stack: Python ETL, star-schema warehouse, Power Query, DAX, Power BI, GitHub Actions. Full details: [`DA-01/README.md`](DA-01/README.md).

![Architecture](DA-01/docs/img/architecture.png)

## Feature breakdown
- **ETL** (`DA-01/etl/build_warehouse.py`): extracts 19 AdventureWorks tables + the IBM HR attrition file, cleanses and conforms them, joins sales to the *historical* standard cost (as-of join, 99.95% of lines), builds the date dimension, and loads a star schema (4 facts, 7 dimensions) in about 4 seconds. Idempotent and deterministic.
- **Data model**: conformed dimensions (`DimDate`, `DimProduct`), transaction-grain facts, 19 relationships - see [`DA-01/docs/DATA_MODEL.md`](DA-01/docs/DATA_MODEL.md).
- **DAX**: 60 measures - YTD, QTD, MTD, year-over-year, margin %, rolling 3-/12-month averages, rankings, supply-chain, production and HR KPIs ([`DA-01/dax/measures.dax`](DA-01/dax/measures.dax)).
- **Report**: 7 pages - Executive Overview, Sales Performance, Region Detail (drill-through), Supply Chain, HR Workforce, HR Attrition, About & Security ([`DA-01/powerbi/`](DA-01/powerbi/), design in [`DA-01/docs/REPORT_DESIGN.md`](DA-01/docs/REPORT_DESIGN.md)).
- **Row-level security**: one dynamic, fail-closed role driven by a `SecurityMap` table; region managers get no supply-chain or HR rows ([`DA-01/dax/rls_roles.dax`](DA-01/dax/rls_roles.dax)).
- **Scheduled data movement**: nightly GitHub Actions job (ETL, then tests, then commit); the Azure Data Factory equivalent is documented in [`DA-01/docs/ADF_MAPPING.md`](DA-01/docs/ADF_MAPPING.md).
- **Quality**: 60 automated tests (reconciliation to source, key integrity, RLS simulation, DAX-logic parity, performance, Power BI project integrity) - results in [`DA-01/docs/TEST_RESULTS.md`](DA-01/docs/TEST_RESULTS.md).
- **Interactive preview** of the dashboard with a security "View as" selector: `DA-01/docs/demo/dashboard.html`.

## Installation and run steps

```bash
git clone https://github.com/<user>/<repo>.git
cd <repo>/DA-01
python -m venv .venv && source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
bash scripts/download_data.sh                            # AdventureWorks CSVs (~46 MB), git-ignored
python etl/build_warehouse.py                            # builds data/warehouse/*.csv in ~4 s
python -m pytest tests -q                                # 60 tests
```

**Power BI:** copy the 13 CSVs from `DA-01/data/warehouse/` to `C:\bi-suite\data\warehouse\` (or change the `DataFolder` parameter), open `DA-01/powerbi/EnterpriseBI.pbip` in Power BI Desktop (preview features: PBIP, TMDL, PBIR), click Refresh. Step-by-step: [`DA-01/docs/POWER_BI_BUILD_GUIDE.md`](DA-01/docs/POWER_BI_BUILD_GUIDE.md), publishing: [`DA-01/docs/DEPLOYMENT.md`](DA-01/docs/DEPLOYMENT.md).

## Headline results
Net sales $109.8M (30 May 2022 - 29 Jun 2025); 2024 grew 38.2% on 2023; margin 11.4% overall - online about 41% vs reseller 0.6% (resellers are 73% of revenue). HR attrition: 30.5% with overtime vs 10.4% without. All numbers reconcile to the source and are listed in [`DA-01/docs/DAX_REFERENCE_VALUES.md`](DA-01/docs/DAX_REFERENCE_VALUES.md).

**Data caveat:** the AdventureWorks extract has no reseller orders after 30 Apr 2025 and online sales collapse in June 2025; treat May-June 2025 as incomplete.

## Screenshots
See [`DA-01/screenshots/`](DA-01/screenshots/).

## Attribution
AdventureWorks sample database (c) Microsoft, MIT licence. IBM HR Employee Attrition dataset: public sample data (Kaggle). Source code MIT licence.
