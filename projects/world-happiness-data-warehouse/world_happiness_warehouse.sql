--------------- ELT ----------------------
--Inspecting column names
PRAGMA table_info(stg_sdr_raw);
PRAGMA table_info(stg_whi_raw);
PRAGMA table_info(stg_gni_raw);

--Trimming whitespaces, fixing types and normalising casing
--SDG
UPDATE stg_sdr_raw SET country = TRIM(country);
UPDATE stg_sdr_raw SET year = CAST(year AS INTEGER);

--WHI
UPDATE stg_whi_raw SET "Country" = TRIM("Country");
UPDATE stg_whi_raw SET Year = CAST(Year AS INTEGER);

--GNI
UPDATE stg_gni_raw SET Country = TRIM(Country);
UPDATE stg_gni_raw SET Year = CAST(Year AS INTEGER);
UPDATE stg_gni_raw SET "Income Level" = UPPER(TRIM("Income Level"));

--Turning empty strings into NULLs
--GNI
UPDATE stg_gni_raw SET "Country"  = NULL WHERE "Country"  = '';
UPDATE stg_gni_raw SET "Year"  = NULL WHERE "Year"  = '';
UPDATE stg_gni_raw SET "Income Level"  = NULL WHERE "Income Level"  = '';

--SDG
UPDATE stg_sdr_raw SET "country_code"  = NULL WHERE "country_code"  = '';
UPDATE stg_sdr_raw SET "country"  = NULL WHERE "country"  = '';
UPDATE stg_sdr_raw SET "year"  = NULL WHERE "year"  = '';
UPDATE stg_sdr_raw SET sdg_index_score  = NULL WHERE sdg_index_score  = '';
UPDATE stg_sdr_raw SET goal_1_score  = NULL WHERE goal_1_score  = '';
UPDATE stg_sdr_raw SET goal_2_score  = NULL WHERE goal_2_score  = '';
UPDATE stg_sdr_raw SET goal_3_score  = NULL WHERE goal_3_score  = '';
UPDATE stg_sdr_raw SET goal_4_score  = NULL WHERE goal_4_score  = '';
UPDATE stg_sdr_raw SET goal_5_score  = NULL WHERE goal_5_score  = '';
UPDATE stg_sdr_raw SET goal_6_score  = NULL WHERE goal_6_score  = '';
UPDATE stg_sdr_raw SET goal_7_score  = NULL WHERE goal_7_score  = '';
UPDATE stg_sdr_raw SET goal_8_score  = NULL WHERE goal_8_score  = '';
UPDATE stg_sdr_raw SET goal_9_score  = NULL WHERE goal_9_score  = '';
UPDATE stg_sdr_raw SET goal_10_score  = NULL WHERE goal_10_score  = '';
UPDATE stg_sdr_raw SET goal_11_score  = NULL WHERE goal_11_score  = '';
UPDATE stg_sdr_raw SET goal_12_score  = NULL WHERE goal_12_score  = '';
UPDATE stg_sdr_raw SET goal_13_score  = NULL WHERE goal_13_score  = '';
UPDATE stg_sdr_raw SET goal_14_score  = NULL WHERE goal_14_score  = '';
UPDATE stg_sdr_raw SET goal_15_score  = NULL WHERE goal_15_score  = '';
UPDATE stg_sdr_raw SET goal_16_score  = NULL WHERE goal_16_score  = '';
UPDATE stg_sdr_raw SET goal_17_score  = NULL WHERE goal_17_score  = '';

--WHI
UPDATE stg_whi_raw SET "Country"  = NULL WHERE "Country"  = '';
UPDATE stg_whi_raw SET "Year"  = NULL WHERE "Year"  = '';
UPDATE stg_whi_raw SET "Index"  = NULL WHERE "Index"  = '';
UPDATE stg_whi_raw SET "Rank"  = NULL WHERE "Rank"  = '';

--Distinct country counts

SELECT DISTINCT country FROM stg_sdr_raw ORDER BY 1;
SELECT DISTINCT "Country" FROM stg_whi_raw ORDER BY 1;
SELECT DISTINCT Country FROM stg_gni_raw ORDER BY 1;

SELECT 'SDR' AS src, COUNT(DISTINCT country) AS n_countries FROM stg_sdr_raw
UNION ALL
SELECT 'WHI', COUNT(DISTINCT "Country") FROM stg_whi_raw
UNION ALL
SELECT 'GNI', COUNT(DISTINCT Country) FROM stg_gni_raw;

--Mismatched country names across sources
--Countries in SDG but not in WHI
SELECT DISTINCT s.country
FROM stg_sdr_raw s
LEFT JOIN stg_whi_raw w ON w."Country" = s.country
WHERE w."Country" IS NULL
ORDER BY 1;

--Count
SELECT COUNT(*) AS sdg_not_in_whi
FROM (
  SELECT DISTINCT s.country
  FROM stg_sdr_raw s
  LEFT JOIN stg_whi_raw w ON w."Country" = s.country
  WHERE w."Country" IS NULL
);


--Countries in WHI but not in SDG
SELECT DISTINCT w."Country"
FROM stg_whi_raw w
LEFT JOIN stg_sdr_raw s ON s.country = w."Country"
WHERE s.country IS NULL
ORDER BY 1;

--Count
SELECT COUNT(*) AS whi_not_in_sdg
FROM (
  SELECT DISTINCT w."Country"
  FROM stg_whi_raw w
  LEFT JOIN stg_sdr_raw s ON s.country = w."Country"
  WHERE s.country IS NULL
);

--Countries in SDG but not in GNI
SELECT DISTINCT s.country
FROM stg_sdr_raw s
LEFT JOIN stg_gni_raw g ON g.Country = s.country
WHERE g.Country IS NULL
ORDER BY 1;

--Count
SELECT COUNT(*) AS sdg_not_in_gni
FROM (
  SELECT DISTINCT s.country
  FROM stg_sdr_raw s
  LEFT JOIN stg_gni_raw g ON g.Country = s.country
  WHERE g.Country IS NULL
);

--Countries in GNI but not in SDG
SELECT DISTINCT g.Country
FROM stg_gni_raw g
LEFT JOIN stg_sdr_raw s ON s.country = g.Country
WHERE s.country IS NULL
ORDER BY 1;

--Count
SELECT COUNT(*) AS gni_not_in_sdg
FROM (
  SELECT DISTINCT g.Country
  FROM stg_gni_raw g
  LEFT JOIN stg_sdr_raw s ON s.country = g.Country
  WHERE s.country IS NULL
);

--Countries in WHI but not in GNI
SELECT DISTINCT w."Country"
FROM stg_whi_raw w
LEFT JOIN stg_gni_raw g ON g.Country = w."Country"
WHERE g.Country IS NULL
ORDER BY 1;

--Count
SELECT COUNT(*) AS whi_not_in_gni
FROM (
  SELECT DISTINCT w."Country"
  FROM stg_whi_raw w
  LEFT JOIN stg_gni_raw g ON g.Country = w."Country"
  WHERE g.Country IS NULL
);

--Countries in GNI but not in WHI
SELECT DISTINCT g.Country
FROM stg_gni_raw g
LEFT JOIN stg_whi_raw w ON w."Country" = g.Country
WHERE w."Country" IS NULL
ORDER BY 1;

--Count
SELECT COUNT(*) AS gni_not_in_whi
FROM (
  SELECT DISTINCT g.Country
  FROM stg_gni_raw g
  LEFT JOIN stg_whi_raw w ON w."Country" = g.Country
  WHERE w."Country" IS NULL
);

--Year Ranges (min/max per dataset)
SELECT 'SDR' AS src, MIN(year) AS min_year, MAX(year) AS max_year FROM stg_sdr_raw
UNION ALL
SELECT 'WHI', MIN(Year), MAX(Year) FROM stg_whi_raw
UNION ALL
SELECT 'GNI', MIN(Year), MAX(Year) FROM stg_gni_raw;

--Duplicates
--SDG
SELECT country, year, COUNT(*) AS n
FROM stg_sdr_raw
GROUP BY country, year
HAVING COUNT(*) > 1
ORDER BY country, year;

--WHI
SELECT "Country" AS country, Year AS year, COUNT(*) AS n
FROM stg_whi_raw
GROUP BY "Country", Year
HAVING COUNT(*) > 1
ORDER BY country, year;

--GNI
SELECT Country AS country, Year AS year, COUNT(*) AS n
FROM stg_gni_raw
GROUP BY Country, Year
HAVING COUNT(*) > 1
ORDER BY country, year;

--Final Summary counts
--Simple totals
SELECT 'SDR' AS src, COUNT(*) AS rows,
       COUNT(DISTINCT country) AS n_countries,
       COUNT(DISTINCT year)    AS n_years
FROM stg_sdr_raw
UNION ALL
SELECT 'WHI', COUNT(*),
       COUNT(DISTINCT "Country"),
       COUNT(DISTINCT Year)
FROM stg_whi_raw
UNION ALL
SELECT 'GNI', COUNT(*),
       COUNT(DISTINCT Country),
       COUNT(DISTINCT Year)
FROM stg_gni_raw;

-- Strict intersection (Country–Year present in ALL THREE)
WITH s AS (SELECT DISTINCT country, year FROM stg_sdr_raw),
     h AS (SELECT DISTINCT "Country" AS country, Year AS year FROM stg_whi_raw),
     g AS (SELECT DISTINCT Country  AS country, Year AS year FROM stg_gni_raw),
     inter AS (
       SELECT s.country, s.year
       FROM s
       JOIN h USING(country, year)
       JOIN g USING(country, year)
     )
SELECT COUNT(*)                AS rows_in_all_three,
       COUNT(DISTINCT country) AS countries_in_all_three,
       MIN(year)               AS min_year,
       MAX(year)               AS max_year
FROM inter;

--Creating DimIncome Dimension Table since it is a tiny dimension
CREATE TABLE IF NOT EXISTS DimIncome(
  income_key     INTEGER PRIMARY KEY,
  income_code    TEXT UNIQUE,         -- 'L','LM','UM','H'
  income_label   TEXT,                -- 'Low income', etc.
  income_order   INTEGER              -- for ordered sorting H>UM>LM>L (or L<LM<UM<H if you prefer)
);

INSERT OR IGNORE INTO DimIncome (income_code, income_label, income_order) VALUES
('L',  'Low income',             1),
('LM', 'Lower middle income',    2),
('UM', 'Upper middle income',    3),
('H',  'High income',            4);

--Sanity Check for DimIncome
SELECT * FROM DimIncome ORDER BY income_order;

--Creating long staging tables
CREATE TABLE IF NOT EXISTS stg_whi_long (
  country        TEXT,
  year           INTEGER,
  indicator_code TEXT,
  indicator_name TEXT,
  unit_name      TEXT,
  value          REAL,
  source_name    TEXT
);

CREATE INDEX IF NOT EXISTS ix_whi_long_cy ON stg_whi_long(country, year);
CREATE INDEX IF NOT EXISTS ix_whi_long_ind ON stg_whi_long(indicator_code);

CREATE TABLE IF NOT EXISTS stg_sdr_long (
  country        TEXT,
  year           INTEGER,
  indicator_code TEXT,
  indicator_name TEXT,
  sdg_goal       INTEGER,
  unit_name      TEXT,
  value          REAL,
  source_name    TEXT
);

CREATE INDEX IF NOT EXISTS ix_sdr_long_cy  ON stg_sdr_long(country, year);
CREATE INDEX IF NOT EXISTS ix_sdr_long_ind ON stg_sdr_long(indicator_code);

--WHI Inserts
-- Happiness Score (Index)
INSERT INTO stg_whi_long
SELECT Country, Year,
       'HAPPINESS_RANK','Happiness Rank','rank',
       CAST(Rank AS REAL),'WHI'
FROM stg_whi_raw
WHERE Rank IS NOT NULL AND TRIM(Rank) <> '';

INSERT INTO stg_whi_long
SELECT "Country", "Year",
       'HAPPINESS_SCORE','Happiness Score','score',
       CAST("Index" AS REAL),'WHI'
FROM stg_whi_raw
WHERE "Index" IS NOT NULL
  AND TRIM(CAST("Index" AS TEXT)) <> ''
  AND UPPER(TRIM(CAST("Index" AS TEXT))) <> 'NULL';
  
--Sanity Check
SELECT indicator_code, COUNT(*) 
FROM stg_whi_long
GROUP BY indicator_code;

--SDG Long Table
-- SDG Index
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG_INDEX','SDG Index',NULL,'score',
       CASE
         WHEN "sdg_index" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("sdg_index" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("sdg_index" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

--Goal 1
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG01','SDG 1: No Poverty',1,'score',
       CASE
         WHEN "goal_1_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_1_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_1_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

--Goal 2
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG02','SDG 2: Zero Hunger',2,'score',
       CASE
         WHEN "goal_2_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_2_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_2_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 3
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG03','SDG 3: Good Health and Well-being',3,'score',
       CASE
         WHEN "goal_3_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_3_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_3_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 4
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG04','SDG 4: Quality Education',4,'score',
       CASE
         WHEN "goal_4_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_4_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_4_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 5
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG05','SDG 5: Gender Equality',5,'score',
       CASE
         WHEN "goal_5_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_5_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_5_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 6
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG06','SDG 6: Clean Water and Sanitation',6,'score',
       CASE
         WHEN "goal_6_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_6_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_6_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 7
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG07','SDG 7: Affordable and Clean Energy',7,'score',
       CASE
         WHEN "goal_7_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_7_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_7_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 8
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG08','SDG 8: Decent Work and Economic Growth',8,'score',
       CASE
         WHEN "goal_8_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_8_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_8_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 9
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG09','SDG 9: Industry, Innovation, and Infrastructure',9,'score',
       CASE
         WHEN "goal_9_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_9_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_9_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 10
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG10','SDG 10: Reduced Inequalities',10,'score',
       CASE
         WHEN "goal_10_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_10_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_10_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 11
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG11','SDG 11: Sustainable Cities and Communities',11,'score',
       CASE
         WHEN "goal_11_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_11_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_11_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 12
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG12','SDG 12: Responsible Consumption and Production',12,'score',
       CASE
         WHEN "goal_12_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_12_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_12_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 13
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG13','SDG 13: Climate Action',13,'score',
       CASE
         WHEN "goal_13_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_13_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_13_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 14
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG14','SDG 14: Life Below Water',14,'score',
       CASE
         WHEN "goal_14_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_14_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_14_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 15
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG15','SDG 15: Life on Land',15,'score',
       CASE
         WHEN "goal_15_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_15_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_15_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 16
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG16','SDG 16: Peace, Justice, and Strong Institutions',16,'score',
       CASE
         WHEN "goal_16_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_16_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_16_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

-- Goal 17
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG17','SDG 17: Partnerships for the Goals',17,'score',
       CASE
         WHEN "goal_17_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("goal_17_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("goal_17_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

--SDG Index
INSERT INTO stg_sdr_long
SELECT "country","year",
       'SDG_INDEX','SDG Index',NULL,'score',
       CASE
         WHEN "sdg_index_score" IS NULL THEN NULL
         WHEN UPPER(TRIM(CAST("sdg_index_score" AS TEXT))) IN ('','NULL','N/A') THEN NULL
         ELSE CAST(REPLACE(TRIM(CAST("sdg_index_score" AS TEXT)), ',', '') AS REAL)
       END,
       'SDR'
FROM stg_sdr_raw;

--Quick QA Checks
--Spotcheck for a country-year shows both index+goals
SELECT *
FROM stg_sdr_long
WHERE country='India' AND year=2018
ORDER BY indicator_code;

--SDG Index should always have SDG_Goal as NULL
SELECT COUNT(*) AS index_with_goal_should_be_zero
FROM stg_sdr_long
WHERE indicator_code = 'SDG_INDEX' AND sdg_goal IS NOT NULL;

--Goals should have 1..17 and never NULL
SELECT sdg_goal, COUNT(*) AS rows
FROM stg_sdr_long
WHERE indicator_code BETWEEN 'SDG01' AND 'SDG17'
GROUP BY sdg_goal
ORDER BY sdg_goal;

-------------------END OF ELT-------------------------------------

-------------CREATING THE STAR SCHEMA-----------------------

-- Dimension Table TIME
CREATE TABLE IF NOT EXISTS DimTime (
  time_key     INTEGER PRIMARY KEY,
  year         INTEGER UNIQUE NOT NULL,
  decade_label TEXT
);

-- Dimension Table COUNTRY
CREATE TABLE IF NOT EXISTS DimCountry (
  country_key   INTEGER PRIMARY KEY,
  country_name  TEXT UNIQUE NOT NULL
);

-- Dimension Table INDICATOR (SDG goals/index + WHI metrics)
CREATE TABLE IF NOT EXISTS DimIndicator (
  indicator_key     INTEGER PRIMARY KEY,
  indicator_code    TEXT UNIQUE NOT NULL,
  indicator_name    TEXT NOT NULL,
  indicator_group   TEXT NOT NULL,      -- SDG_GOAL | SDG_INDEX | HAPPINESS_CORE | HAPPINESS_DRIVER
  sdg_goal          INTEGER,            -- 1..17 for SDGs, NULL otherwise
  unit_name         TEXT,
  higher_is_better  INTEGER NOT NULL DEFAULT 1 CHECK (higher_is_better IN (0,1)),
  source_name       TEXT NOT NULL
);

-- Dimension Table INCOME (already created; keep here for completeness)
CREATE TABLE IF NOT EXISTS DimIncome (
  income_key    INTEGER PRIMARY KEY,
  income_code   TEXT UNIQUE NOT NULL,   -- L, LM, UM, H
  income_label  TEXT NOT NULL,          -- Low..., Lower..., Upper..., High...
  income_order  INTEGER NOT NULL        -- 1..4 for sorting
);

-- helpful indexes
CREATE UNIQUE INDEX IF NOT EXISTS ux_dimtime_year       ON DimTime(year);
CREATE UNIQUE INDEX IF NOT EXISTS ux_dimcountry_name    ON DimCountry(country_name);
CREATE UNIQUE INDEX IF NOT EXISTS ux_dimindicator_code  ON DimIndicator(indicator_code);
CREATE INDEX        IF NOT EXISTS ix_dimindicator_group ON DimIndicator(indicator_group);

--Populating the Dimension Tables
--Dimension Time Population
INSERT OR IGNORE INTO DimTime (year, decade_label)
SELECT y, CAST((y/10)*10 AS TEXT) || 's'
FROM (
  SELECT DISTINCT year AS y FROM stg_sdr_long
  UNION
  SELECT DISTINCT year       FROM stg_whi_long
  UNION
  SELECT DISTINCT "Year"     FROM stg_gni_raw   -- note the capitalized column name
)
ORDER BY y;

--Dimension Country Population
INSERT OR IGNORE INTO DimCountry (country_name)
SELECT country_name FROM (
  SELECT DISTINCT country AS country_name FROM stg_sdr_long
  UNION
  SELECT DISTINCT country                 FROM stg_whi_long
  UNION
  SELECT DISTINCT "Country"               FROM stg_gni_raw
);

--Dimension Indicator Population
INSERT OR IGNORE INTO DimIndicator
  (indicator_code, indicator_name, indicator_group, sdg_goal, unit_name, higher_is_better, source_name)
SELECT DISTINCT
  l.indicator_code,
  l.indicator_name,
  CASE WHEN l.indicator_code='SDG_INDEX' THEN 'SDG_INDEX' ELSE 'SDG_GOAL' END AS indicator_group,
  l.sdg_goal,
  l.unit_name,
  1 AS higher_is_better,
  l.source_name
FROM stg_sdr_long l;

-- WHI (score + rank) – if you loaded only core, this inserts 2 rows
INSERT OR IGNORE INTO DimIndicator
  (indicator_code, indicator_name, indicator_group, sdg_goal, unit_name, higher_is_better, source_name)
VALUES
  ('HAPPINESS_SCORE','Happiness Score','HAPPINESS_CORE',NULL,'score',1,'WHI'),
  ('HAPPINESS_RANK', 'Happiness Rank', 'HAPPINESS_CORE',NULL,'rank', 0,'WHI');
  
--Creating Fact Table
CREATE TABLE IF NOT EXISTS FactCountryYearIndicator (
  fact_key       INTEGER PRIMARY KEY,
  time_key       INTEGER NOT NULL,
  country_key    INTEGER NOT NULL,
  indicator_key  INTEGER NOT NULL,
  income_key     INTEGER,              -- from GNI (nullable if missing)
  value_numeric  REAL,
  value_std      REAL,
  FOREIGN KEY (time_key)      REFERENCES DimTime(time_key),
  FOREIGN KEY (country_key)   REFERENCES DimCountry(country_key),
  FOREIGN KEY (indicator_key) REFERENCES DimIndicator(indicator_key),
  FOREIGN KEY (income_key)    REFERENCES DimIncome(income_key)
);

-- performance indexes
CREATE INDEX IF NOT EXISTS ix_fact_time       ON FactCountryYearIndicator(time_key);
CREATE INDEX IF NOT EXISTS ix_fact_country    ON FactCountryYearIndicator(country_key);
CREATE INDEX IF NOT EXISTS ix_fact_indicator  ON FactCountryYearIndicator(indicator_key);
CREATE INDEX IF NOT EXISTS ix_fact_income     ON FactCountryYearIndicator(income_key);

--Inserting into FACT Table
--WHI to Fact Table
INSERT INTO FactCountryYearIndicator
  (time_key, country_key, indicator_key, income_key, value_numeric)
SELECT
  t.time_key,
  c.country_key,
  i.indicator_key,
  d.income_key,
  w.value
FROM stg_whi_long w
JOIN DimTime      t ON t.year = w.year
JOIN DimCountry   c ON c.country_name = w.country
JOIN DimIndicator i ON i.indicator_code = w.indicator_code
LEFT JOIN stg_gni_raw g ON g."Country" = w.country AND g."Year" = w.year
LEFT JOIN DimIncome   d ON d.income_code = g."Income Level";

--SDG to Fact Table
INSERT INTO FactCountryYearIndicator
  (time_key, country_key, indicator_key, income_key, value_numeric)
SELECT
  t.time_key,
  c.country_key,
  i.indicator_key,
  d.income_key,
  s.value
FROM stg_sdr_long s
JOIN DimTime      t ON t.year = s.year
JOIN DimCountry   c ON c.country_name = s.country
JOIN DimIndicator i ON i.indicator_code = s.indicator_code
LEFT JOIN stg_gni_raw g ON g.Country = s.country AND g.Year = s.year
LEFT JOIN DimIncome   d ON d.income_code = g."Income Level";

--Integrity and Coverage Checks
SELECT COUNT(*) AS bad_time_fk
FROM FactCountryYearIndicator f LEFT JOIN DimTime t ON t.time_key=f.time_key
WHERE t.time_key IS NULL;

SELECT COUNT(*) AS bad_country_fk
FROM FactCountryYearIndicator f LEFT JOIN DimCountry c ON c.country_key=f.country_key
WHERE c.country_key IS NULL;

SELECT COUNT(*) AS bad_indicator_fk
FROM FactCountryYearIndicator f LEFT JOIN DimIndicator i ON i.indicator_key=f.indicator_key
WHERE i.indicator_key IS NULL;

--Income Coverage
SELECT
  SUM(CASE WHEN income_key IS NULL THEN 1 ELSE 0 END) AS facts_without_income,
  COUNT(*) AS total_facts
FROM FactCountryYearIndicator;

-- Row counts by indicator family
SELECT i.indicator_group, COUNT(*) AS rows
FROM FactCountryYearIndicator f
JOIN DimIndicator i ON i.indicator_key=f.indicator_key
GROUP BY i.indicator_group;

-- India 2018 spot check (should show SDG index+goals + WHI)
SELECT c.country_name, t.year, i.indicator_code, i.indicator_name, f.value_numeric
FROM FactCountryYearIndicator f
JOIN DimCountry c   ON c.country_key=f.country_key
JOIN DimTime t      ON t.time_key=f.time_key
JOIN DimIndicator i ON i.indicator_key=f.indicator_key
WHERE c.country_name='India' AND t.year=2018
ORDER BY i.indicator_code;

-------------------------- END OF STAR SCHEMA  ---------------------------------------------------
--Creating View for analytics
CREATE VIEW vw_country_year_summary AS
SELECT
    c.country_name    AS Country,
    t.year            AS Year,
    -- Happiness Index (score)
    MAX(CASE WHEN i.indicator_code = 'HAPPINESS_SCORE' THEN f.value_numeric END) AS Happiness_Index,
    -- Happiness Rank
    MAX(CASE WHEN i.indicator_code = 'HAPPINESS_RANK' THEN f.value_numeric END)  AS Happiness_Rank,
    -- SDG Index
    MAX(CASE WHEN i.indicator_code = 'SDG_INDEX' THEN f.value_numeric END)       AS SDG_Index,
    -- Income group from DimIncome
    dinc.income_label AS Income_Level
FROM FactCountryYearIndicator f
JOIN DimCountry   c    ON c.country_key   = f.country_key
JOIN DimTime      t    ON t.time_key      = f.time_key
JOIN DimIndicator i    ON i.indicator_key = f.indicator_key
LEFT JOIN DimIncome   dinc ON dinc.income_key = f.income_key
GROUP BY c.country_name, t.year, dinc.income_label
ORDER BY c.country_name, t.year;

SELECT * FROM vw_country_year_summary
WHERE Country = 'India'
ORDER BY Year;

--SQL Analytics
--Research Question 1
--Relationship between Happiness and Sustainable Development

-- Country*Year pairs with BOTH metrics
SELECT Country, Year, SDG_Index, Happiness_Index
FROM vw_country_year_summary
WHERE SDG_Index IS NOT NULL AND Happiness_Index IS NOT NULL
ORDER BY Country, Year;

--Pearson Correlation (Overall, all years)
WITH pairs AS (
  SELECT SDG_Index AS x, Happiness_Index AS y
  FROM vw_country_year_summary
  WHERE SDG_Index IS NOT NULL AND Happiness_Index IS NOT NULL
),
stats AS (
  SELECT COUNT(*) AS n,
         SUM(x) AS sx, SUM(y) AS sy,
         SUM(x*x) AS sxx, SUM(y*y) AS syy,
         SUM(x*y) AS sxy
  FROM pairs
)
SELECT (n*sxy - sx*sy) /
       NULLIF( sqrt((n*sxx - sx*sx)*(n*syy - sy*sy)), 0 ) AS pearson_r
FROM stats;

--correlation by year
WITH pairs AS (
  SELECT Year, SDG_Index AS x, Happiness_Index AS y
  FROM vw_country_year_summary
  WHERE SDG_Index IS NOT NULL AND Happiness_Index IS NOT NULL
),
stats AS (
  SELECT Year,
         COUNT(*) n, SUM(x) sx, SUM(y) sy,
         SUM(x*x) sxx, SUM(y*y) syy, SUM(x*y) sxy
  FROM pairs
  GROUP BY Year
)
SELECT Year,
       (n*sxy - sx*sy) /
       NULLIF( sqrt((n*sxx - sx*sx)*(n*syy - sy*sy)), 0 ) AS pearson_r
FROM stats
ORDER BY Year;

--Top 10 happy countries
WITH latest AS (
  SELECT MAX(Year) AS y
  FROM vw_country_year_summary
  WHERE SDG_Index IS NOT NULL AND Happiness_Index IS NOT NULL
)
SELECT Country, Year, Happiness_Index, SDG_Index
FROM vw_country_year_summary, latest
WHERE Year = latest.y
  AND Happiness_Index IS NOT NULL
  AND SDG_Index IS NOT NULL
ORDER BY Happiness_Index DESC
LIMIT 10;

--Bottom 10 unhappy countries
WITH latest AS (
  SELECT MAX(Year) AS y
  FROM vw_country_year_summary
  WHERE SDG_Index IS NOT NULL AND Happiness_Index IS NOT NULL
)
SELECT Country, Year, Happiness_Index, SDG_Index
FROM vw_country_year_summary, latest
WHERE Year = latest.y
  AND Happiness_Index IS NOT NULL
  AND SDG_Index IS NOT NULL
ORDER BY Happiness_Index ASC
LIMIT 10;


--Research Question 2
--Relating GNI to Happiness

SELECT Country, Year, Happiness_Index, Income_Level
FROM vw_country_year_summary
WHERE Happiness_Index IS NOT NULL AND Income_Level IS NOT NULL;

-- Latest shared year example: change/remove the Year filter as you like
SELECT Income_Level,
       AVG(Happiness_Index) AS avg_happiness,
       COUNT(*)             AS n_country_years
FROM vw_country_year_summary
WHERE Happiness_Index IS NOT NULL
GROUP BY Income_Level
ORDER BY CASE Income_Level
  WHEN 'Low income' THEN 1
  WHEN 'Lower middle income' THEN 2
  WHEN 'Upper middle income' THEN 3
  WHEN 'High income' THEN 4
END;

--Top 10 High-Income Countries by Happiness Index (Latest Year)
SELECT 
    c.country_name AS Country,
    t.year AS Year,
    f.value_numeric AS Happiness_Index,
    d.income_label AS Income_Level
FROM FactCountryYearIndicator f
JOIN DimCountry c   ON f.country_key = c.country_key
JOIN DimTime t      ON f.time_key = t.time_key
JOIN DimIndicator i ON f.indicator_key = i.indicator_key
JOIN DimIncome d    ON f.income_key = d.income_key
WHERE i.indicator_code = 'HAPPINESS_SCORE'
  AND d.income_label = 'High income'
  AND t.year = (SELECT MAX(year) FROM DimTime)
ORDER BY f.value_numeric DESC
LIMIT 10;

--Bottom 10 Low-Income Countries by Happiness Index (Latest Year)
SELECT 
    c.country_name AS Country,
    t.year AS Year,
    f.value_numeric AS Happiness_Index,
    d.income_label AS Income_Level
FROM FactCountryYearIndicator f
JOIN DimCountry c   ON f.country_key = c.country_key
JOIN DimTime t      ON f.time_key = t.time_key
JOIN DimIndicator i ON f.indicator_key = i.indicator_key
JOIN DimIncome d    ON f.income_key = d.income_key
WHERE i.indicator_code = 'HAPPINESS_SCORE'
  AND d.income_label = 'Low income'
  AND t.year = (SELECT MAX(year) FROM DimTime)
ORDER BY f.value_numeric ASC
LIMIT 10;

--Research Question 3
--Multiple regression (Happiness ~ SDG_Index + Income Level)
WITH base AS (
  SELECT
    SDG_Index AS x,                     -- predictor 1
    CASE Income_Level                   -- predictor 2 (numeric)
      WHEN 'Low income' THEN 1
      WHEN 'Lower middle income' THEN 2
      WHEN 'Upper middle income' THEN 3
      WHEN 'High income' THEN 4
    END AS z,
    Happiness_Index AS y
  FROM vw_country_year_summary
  WHERE SDG_Index IS NOT NULL AND Happiness_Index IS NOT NULL
        AND Income_Level IS NOT NULL
),
means AS (
  SELECT AVG(x) AS xbar, AVG(z) AS zbar, AVG(y) AS ybar FROM base
),
cov AS (
  SELECT
    SUM( (b.x - m.xbar)*(b.x - m.xbar) )              AS Sxx,
    SUM( (b.z - m.zbar)*(b.z - m.zbar) )              AS Szz,
    SUM( (b.x - m.xbar)*(b.z - m.zbar) )              AS Sxz,
    SUM( (b.x - m.xbar)*(b.y - m.ybar) )              AS Sxy,
    SUM( (b.z - m.zbar)*(b.y - m.ybar) )              AS Szy,
    COUNT(*)                                          AS n,
    m.xbar, m.zbar, m.ybar
  FROM base b, means m
)
SELECT
  -- Regression coefficients (closed-form for 2 predictors)
  (Sxy*Szz - Szy*Sxz) / (Sxx*Szz - Sxz*Sxz) AS beta_sdg,
  (Szy*Sxx - Sxy*Sxz) / (Sxx*Szz - Sxz*Sxz) AS beta_income,
  -- Intercept
  m.ybar - ((Sxy*Szz - Szy*Sxz) / (Sxx*Szz - Sxz*Sxz))*m.xbar
         - ((Szy*Sxx - Sxy*Sxz) / (Sxx*Szz - Sxz*Sxz))*m.zbar AS intercept,
  n AS rows_used
FROM cov, means m;

--Top 5 SDG Goals most correlated with happiness index for the latest year
WITH latest_common_year AS (
  SELECT MIN(max_y) AS y FROM (
    SELECT MAX(t.year) AS max_y
    FROM FactCountryYearIndicator f
    JOIN DimIndicator i ON i.indicator_key = f.indicator_key
    JOIN DimTime t      ON t.time_key      = f.time_key
    WHERE i.indicator_code = 'HAPPINESS_SCORE'
    UNION ALL
    SELECT MAX(t.year) AS max_y
    FROM FactCountryYearIndicator f
    JOIN DimIndicator i ON i.indicator_key = f.indicator_key
    JOIN DimTime t      ON t.time_key      = f.time_key
    WHERE i.indicator_group = 'SDG_GOAL'   -- SDG01..SDG17
  )
),
happiness AS (
  SELECT f.country_key, f.value_numeric AS y
  FROM FactCountryYearIndicator f
  JOIN DimIndicator i ON i.indicator_key = f.indicator_key
  JOIN DimTime t      ON t.time_key      = f.time_key
  WHERE i.indicator_code = 'HAPPINESS_SCORE'
    AND t.year = (SELECT y FROM latest_common_year)
),
sdg AS (
  SELECT f.country_key, i.indicator_code, i.indicator_name, i.sdg_goal,
         f.value_numeric AS x
  FROM FactCountryYearIndicator f
  JOIN DimIndicator i ON i.indicator_key = f.indicator_key
  JOIN DimTime t      ON t.time_key      = f.time_key
  WHERE i.indicator_group = 'SDG_GOAL'
    AND t.year = (SELECT y FROM latest_common_year)
),
pairs AS (
  SELECT s.indicator_code, s.indicator_name, s.sdg_goal, s.x, h.y
  FROM sdg s
  JOIN happiness h ON h.country_key = s.country_key
  WHERE s.x IS NOT NULL AND h.y IS NOT NULL
),
stats AS (
  SELECT indicator_code, indicator_name, sdg_goal,
         COUNT(*) n,
         SUM(x) sx, SUM(y) sy,
         SUM(x*x) sxx, SUM(y*y) syy, SUM(x*y) sxy
  FROM pairs
  GROUP BY indicator_code, indicator_name, sdg_goal
)
SELECT
  (SELECT y FROM latest_common_year) AS year,
  indicator_code,
  indicator_name,
  sdg_goal,
  (n*sxy - sx*sy) /
  NULLIF( sqrt((n*sxx - sx*sx) * (n*syy - sy*sy)), 0 ) AS pearson_r,
  n AS pairs_used
FROM stats
ORDER BY pearson_r DESC
LIMIT 5;