/* Ce modèle va centraliser les matchs en utilisant les IDs qu'on a préparés dans les dimensions. */
{{ config(materialized='table') }}

WITH matchs AS (
    SELECT * FROM {{ ref('stg_MATCHS') }}
)

SELECT 
    "MATCH_ID",
    -- Utilisation de la même logique de clé que dans ta dimension calendrier
    {{ dbt_utils.generate_surrogate_key(['"SAISON_ID"', '"NUMERO_JOURNEE"']) }} AS "JOURNEE_KEY",
    "SAISON_ID",
    "EQUIPE_DOMICILE_ID",
    "EQUIPE_EXTERIEUR_ID",
    "STADE_ID",
    "DATE_MATCH",
    "BUTS_DOMICILE",
    "BUTS_EXTERIEUR",
    -- Calcul de mesures simples directement dans le fait
    ("BUTS_DOMICILE" + "BUTS_EXTERIEUR") AS "TOTAL_BUTS",
    CASE 
        WHEN "BUTS_DOMICILE" > "BUTS_EXTERIEUR" THEN 'VICTOIRE_DOMICILE'
        WHEN "BUTS_DOMICILE" < "BUTS_EXTERIEUR" THEN 'VICTOIRE_EXTERIEUR'
        ELSE 'NUL'
    END AS "RESULTAT"
FROM matchs