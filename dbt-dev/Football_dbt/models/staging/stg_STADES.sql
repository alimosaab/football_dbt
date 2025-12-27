{{ config(materialized='view') }}

SELECT 
    CAST("stade_id" AS INT) AS STADE_ID,
    "nomStade" AS NOM_STADE,
    "villeStade" AS VILLE_STADE,
    "paysStade" AS PAYS_STADE,
    CAST("capacite" AS INT) AS CAPACITE
FROM {{ source('champions_raw', 'STADES') }}