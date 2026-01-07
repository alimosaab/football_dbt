{{ config(materialized='table') }}

WITH clubs_hors_saison AS (
    SELECT e."EQUIPE_ID", s."SAISON_ID"
    FROM {{ ref('dim_equipes') }} e
    CROSS JOIN {{ ref('dim_saisons') }} s
    LEFT JOIN {{ ref('fct_matchs') }} m 
        ON (e."EQUIPE_ID" = m."EQUIPE_DOMICILE_ID" OR e."EQUIPE_ID" = m."EQUIPE_EXTERIEUR_ID")
        AND s."SAISON_ID" = m."SAISON_ID"
    WHERE m."MATCH_ID" IS NULL -- L'équipe ne joue aucun match cette saison
)

SELECT 
    "SAISON_ID",
    "EQUIPE_ID",
    'PROMUE' as "STATUT"
FROM clubs_hors_saison
ORDER BY RANDOM() -- Sélection au hasard
LIMIT 3