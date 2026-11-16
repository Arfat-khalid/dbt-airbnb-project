{% docs __overview__ %}
# Airbnb Analytics Pipeline

Analytics models for Airbnb listings, hosts and reviews in Berlin, built with **dbt Core on DuckDB**.
The project cleanses the raw data, keeps the history of listings and hosts, and answers one question
in its mart: **are reviews written after a full moon more negative?**

## Input data

Three raw tables from [Inside Airbnb](https://insideairbnb.com/) (CC BY 4.0) plus one seed:

| Table | Rows | Content |
|---|---|---|
| `raw_listings` | 17,499 | listing name, room type, minimum nights, price, host |
| `raw_hosts` | 14,111 | host name, superhost flag |
| `raw_reviews` | 410,284 | review date, reviewer, text, sentiment (Jun 2009 – Oct 2021) |
| `seed_full_moon_dates` | 272 | full moon dates |

![input schema](assets/lineage_graph.png)

## Layers

| Layer | Materialization | Purpose |
|---|---|---|
| `src` | ephemeral | rename source columns, no logic |
| `dim` | table / view | cleansed listings and hosts (`dim_hosts_cleansed` is versioned, with an enforced contract), listings joined with hosts, Python models for long-term listings and holidays on full-moon dates |
| `fct` | incremental | `fct_reviews`, one row per review with a surrogate key; sentiment scores computed in Python |
| `mart` | incremental (microbatch, yearly) | `mart_fullmoon_reviews`, reviews flagged as written the day after a full moon |
| snapshots | SCD Type 2 | `scd_raw_listings`, `scd_raw_hosts` keep every change to listings and hosts |

## Data quality

Every layer is tested: generic tests (unique, not null, relationships, accepted values), custom generic
and singular tests, [dbt_expectations](https://hub.getdbt.com/) checks on prices and row counts, a unit
test for the full-moon matching, and source freshness. Failing rows are stored in the `test_results`
schema for inspection.

## How to navigate these docs

- **Project** tab (left): models by folder; **Database** tab: models by schema.
- Click a model to see its description, columns, tests, and compiled SQL.
- The **lineage graph** (button at the bottom right) shows how sources flow through the layers to the
  `executive_dashboard` exposure. Use `+model+` in the graph's selector to focus on one model.

Source code, setup instructions and CI/CD: [github.com/Arfat-khalid/dbt-airbnb-project](https://github.com/Arfat-khalid/dbt-airbnb-project)

{% enddocs %}
