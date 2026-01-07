{{ config(materialized='view') }}

SELECT 
    CAST("joueur_id" AS INT) AS "JOUEUR_ID",
    "nomJoueur" AS "NOM_JOUEUR",
    "prenomJoueur" AS "PRENOM_JOUEUR",
    "date_naissance" AS "DATE_NAISSANCE",
    CAST("poste_id" AS INT) AS "POSTE_ID",
    "paysJoueur" AS "PAYS_JOUEUR"
FROM {{ source('champions_raw', 'JOUEURS') }}