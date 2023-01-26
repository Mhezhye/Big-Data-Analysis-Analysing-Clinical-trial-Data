-- Databricks notebook source
CREATE EXTERNAL TABLE IF NOT EXISTS clinicaltrial_2021(
Id STRING,
Sponsor STRING,
Status STRING,
Start STRING,
Completion STRING,
Type STRING,
Submission STRING,
Conditions STRING,
Interventions STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
LOCATION '/FileStore/tables/clinicaltrial_2021'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Undo comment in the next cell if you are running this notebook for the first time and convert back to comment once done 

-- COMMAND ----------

--LOAD DATA INPATH '/FileStore/tables/clinicaltrial_2021.csv'
--OVERWRITE INTO TABLE clinicaltrial_2021;

-- COMMAND ----------

CREATE EXTERNAL TABLE IF NOT EXISTS mesh(
Term STRING,
Tree STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
LOCATION '/FileStore/tables/mesh'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Undo comment in the next cell if you are running this notebook for the first time and convert back to comment once done 

-- COMMAND ----------

--LOAD DATA INPATH '/FileStore/tables/mesh.csv'
--OVERWRITE INTO TABLE mesh;

-- COMMAND ----------

CREATE EXTERNAL TABLE IF NOT EXISTS pharma(
Company STRING,
Parent_Company STRING,
Penalty_Amount STRING,
Subtraction_From_Penalty STRING,
Penalty_Amount_Adjusted_For_Eliminating_Multiple_Counting STRING,
Penalty_Year STRING,
Penalty_Date STRING,
Offense_Group STRING,
Primary_Offense STRING,
Secondary_Offense STRING,
Description STRING,
Level_of_Government STRING,
Action_Type STRING,
Agency STRING,
Civil_Criminal STRING,
Prosecution_Agreement STRING,
Court STRING,
Case_ID STRING,
Private_Litigation_Case_Title STRING,
Lawsuit_Resolution STRING,
Facility_State STRING,
City STRING,
Address STRING,
Zip STRING,
NAICS_Code STRING,
NAICS_Translation STRING,
HQ_Country_of_Parent STRING,
HQ_State_of_Parent STRING,
Ownership_Structure STRING,
Parent_Company_Stock_Ticker STRING,
Major_Industry_of_Parent STRING,
Specific_Industry_of_Parent STRING,
Info_Source STRING,
Notes STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
LOCATION '/FileStore/tables/pharma'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Undo comment in the next cell if you are running this notebook for the first time and convert back to comment once done

-- COMMAND ----------

--LOAD DATA INPATH '/FileStore/tables/pharma.csv'
--OVERWRITE INTO TABLE pharma;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Answer 1

-- COMMAND ----------

SELECT DISTINCT COUNT(*) 
FROM clinicaltrial_2021
WHERE Id LIKE 'N%';

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Answer 2

-- COMMAND ----------

SELECT Type, count(*) AS Total
FROM clinicaltrial_2021
GROUP BY Type
ORDER BY Total DESC
LIMIT 4

-- COMMAND ----------

-- MAGIC %md 
-- MAGIC Answer 3

-- COMMAND ----------

SELECT Most_Conditions, count(*) AS Total
FROM clinicaltrial_2021
LATERAL VIEW OUTER explode(split(Conditions,',')) AS Most_Conditions
WHERE Conditions LIKE '%_%'
GROUP BY Most_Conditions
ORDER BY Total DESC 
LIMIT 5

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Answer 4

-- COMMAND ----------

CREATE VIEW IF NOT EXISTS ConditionX AS SELECT Most_Conditions
FROM clinicaltrial_2021
LATERAL VIEW OUTER explode(split(Conditions,',')) as Most_Conditions
WHERE Conditions LIKE '%_%'

-- COMMAND ----------

SELECT substring(mesh.tree,1,3) AS Roots, count(*) AS frequency
FROM mesh
JOIN ConditionX
ON ConditionX.Most_Conditions=mesh.term
GROUP BY Roots
ORDER BY Frequency DESC
LIMIT 5

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Answer 5

-- COMMAND ----------

CREATE VIEW IF NOT EXISTS Pharmaplus AS
SELECT REPLACE(ltrim(rtrim(REPLACE(Parent_Company,'"',''))),'', '"') AS Parent_company2
FROM pharma

-- COMMAND ----------

SELECT clinicaltrial_2021.sponsor, count(*) AS frequency
FROM clinicaltrial_2021
LEFT ANTI JOIN pharmaplus
ON clinicaltrial_2021.sponsor=pharmaplus.parent_company2
GROUP BY clinicaltrial_2021.sponsor
ORDER BY frequency DESC
LIMIT 10

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Answer 6

-- COMMAND ----------

CREATE VIEW IF NOT EXISTS MONTH AS
SELECT unix_timestamp(LEFT(Completion,3),'MMM') AS Months, count(*) AS Total
FROM clinicaltrial_2021
WHERE Status = 'Completed' AND Completion LIKE '%2021'
GROUP BY Completion
ORDER BY Months


-- COMMAND ----------

SELECT from_unixtime(Months,'MMM') AS Months, Total
FROM MONTH
