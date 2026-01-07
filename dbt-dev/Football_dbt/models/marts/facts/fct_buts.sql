{{ config(materialized='table') }}

SELECT 
    "BUT_ID",
    "MATCH_ID",
    "JOUEUR_ID",
    "EQUIPE_BUT_ID" AS "EQUIPE_ID",
    "TYPE_BUT_ID",
    "MINUTE_BUT"
FROM {{ ref('stg_BUTS') }}