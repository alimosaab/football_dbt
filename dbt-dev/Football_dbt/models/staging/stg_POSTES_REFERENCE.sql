{{ config(materialized='view') }}

SELECT 
    CAST("poste_id" AS INT) AS "POSTE_ID",
    "nomPoste" AS "NOM_POSTE"
FROM {{ source('champions_raw', 'POSTES_REFERENCE') }}