{{ config(materialized='table') }}

WITH buts_joueurs AS (
    SELECT 
        b."JOUEUR_ID",
        m."SAISON_ID",
        COUNT(b."BUT_ID") AS "NOMBRE_BUTS"
    FROM {{ ref('fct_buts') }} b
    JOIN {{ ref('fct_matchs') }} m ON b."MATCH_ID" = m."MATCH_ID"
    GROUP BY 1, 2
)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['"JOUEUR_ID"', '"SAISON_ID"']) }} AS "BUTEUR_SAISON_KEY",
    "JOUEUR_ID",
    "SAISON_ID",
    "NOMBRE_BUTS"
FROM buts_joueurs
ORDER BY "SAISON_ID", "NOMBRE_BUTS" DESC