{{ config(materialized='table') }}

SELECT 
    "ENTRAINEUR_ID",
    "NOM_ENTRAINEUR",
    "PRENOM_ENTRAINEUR",
    "PAYS_ENTRAINEUR" AS "NATIONALITE"
FROM {{ ref('stg_ENTRAINEURS') }}