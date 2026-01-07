{{ config(materialized='view') }}

SELECT 
    CAST("saison_id" AS INT) AS "SAISON_ID",
    CAST("annee_debut" AS INT) AS "ANNEE_DEBUT",
    CAST("annee_fin" AS INT) AS "ANNEE_FIN"
FROM {{ source('champions_raw', 'SAISONS') }}