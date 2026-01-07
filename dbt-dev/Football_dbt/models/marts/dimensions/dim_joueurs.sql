/* Cette table va regrouper les informations des joueurs avec le nom de leur poste.*/
{{ config(materialized='table') }}

WITH joueurs AS (
    SELECT * FROM {{ ref('stg_JOUEURS') }}
),

postes AS (
    SELECT * FROM {{ ref('stg_POSTES_REFERENCE') }}
)

SELECT 
    j."JOUEUR_ID",
    j."NOM_JOUEUR",
    j."PRENOM_JOUEUR",
    j."DATE_NAISSANCE",
    j."PAYS_JOUEUR" AS "NATIONALITE",
    p."NOM_POSTE"
FROM joueurs j
LEFT JOIN postes p ON j."POSTE_ID" = p."POSTE_ID"