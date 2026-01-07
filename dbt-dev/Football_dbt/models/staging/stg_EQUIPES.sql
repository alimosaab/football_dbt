{{ config(materialized='view') }}

SELECT 
    CAST("equipe_id" AS INT) AS "EQUIPE_ID",
    "nomEquipe"  AS "NOM_EQUIPE",
    "abreviation" AS "CODE_FIFA",
    "villeEquipe" AS "VILLE",
    "paysEquipe" AS "PAYS",
    CAST("stade_id" AS INT) AS "STADE_ID"
FROM {{ source('champions_raw', 'EQUIPES') }}
