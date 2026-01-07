{{ config(materialized='view') }}

SELECT 
    CAST("match_id" AS INT) AS "MATCH_ID",
    CAST("saison_id" AS INT) AS "SAISON_ID",
    CAST("numero_journee" AS INT) AS "NUMERO_JOURNEE",
    CAST("equipe_domicile_id" AS INT) AS "EQUIPE_DOMICILE_ID",
    CAST("equipe_exterieur_id" AS INT) AS "EQUIPE_EXTERIEUR_ID",
    CAST("stade_id" AS INT) AS "STADE_ID",
    "date_match" AS "DATE_MATCH",
    CAST("buts_domicile" AS INT) AS "BUTS_DOMICILE",
    CAST("buts_exterieur" AS INT) AS "BUTS_EXTERIEUR"
FROM {{ source('champions_raw', 'MATCHS') }}