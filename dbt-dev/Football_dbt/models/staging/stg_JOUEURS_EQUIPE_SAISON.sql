{{ config(materialized='view') }}

SELECT 
    CAST("contrat_id" AS INT) AS "CONTRAT_ID",
    CAST("saison_id" AS INT) AS "SAISON_ID",
    CAST("joueur_id" AS INT) AS "JOUEUR_ID",
    CAST("equipe_id" AS INT) AS "EQUIPE_ID",
    "date_arrivee" AS "DATE_ARRIVEE"
FROM {{ source('champions_raw', 'JOUEURS_EQUIPE_SAISON') }}