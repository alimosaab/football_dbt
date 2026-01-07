{{ config(materialized='table') }}

WITH classement AS (
    SELECT * FROM {{ ref('fct_classement') }}
),

rangs AS (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY "SAISON_ID" ORDER BY "TOTAL_POINTS" ASC, "DIFFERENCE_BUTS" ASC) as rang_inverse
    FROM classement
)

SELECT 
    "SAISON_ID",
    "EQUIPE_ID",
    "TOTAL_POINTS",
    'RELEGUE' as "STATUT"
FROM rangs
WHERE rang_inverse <= 3