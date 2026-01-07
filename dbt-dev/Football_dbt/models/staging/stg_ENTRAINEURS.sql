{{ config(materialized='view') }}

SELECT 
    CAST("entraineur_id" AS INT) AS "ENTRAINEUR_ID",
    "nomEntraineur" AS "NOM_ENTRAINEUR",
    "prenomEntraineur" AS "PRENOM_ENTRAINEUR",
    "paysEntraineur" AS "PAYS_ENTRAINEUR"
FROM {{ source('champions_raw', 'ENTRAINEURS') }}