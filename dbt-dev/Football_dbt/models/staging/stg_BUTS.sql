{{ config(materialized='view') }}

SELECT 
    CAST("but_id" AS INT) AS "BUT_ID",
    CAST("match_id" AS INT) AS "MATCH_ID",
    CAST("joueur_id" AS INT) AS "JOUEUR_ID",
    CAST("equipe_but_id" AS INT) AS "EQUIPE_BUT_ID",
    CAST("minute_but" AS INT) AS "MINUTE_BUT",
    CAST("type_but_id" AS INT) AS "TYPE_BUT_ID"
FROM {{ source('champions_raw', 'BUTS') }}