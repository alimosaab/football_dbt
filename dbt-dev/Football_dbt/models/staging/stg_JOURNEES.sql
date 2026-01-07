{{ config(materialized='view') }}

SELECT 
    CAST("saison_id" AS INT) AS "SAISON_ID",
    CAST("numero_journee" AS INT) AS "NUMERO_JOURNEE",
    "date_limite" AS "DATE_LIMITE"
FROM {{ source('champions_raw', 'JOURNEES') }}