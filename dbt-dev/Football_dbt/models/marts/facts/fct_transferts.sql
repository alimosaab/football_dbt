{{ config(materialized='table') }}

SELECT 
    "TRANSFERT_ID",
    "JOUEUR_ID",
    "ENTRAINEUR_ID",
    "SAISON_ID",
    "ANCIENNE_EQUIPE_ID",
    "NOUVELLE_EQUIPE_ID",
    "DATE_TRANSFERT",
    "MONTANT_TRANSFERT",
    "TYPE_TRANSFERT"
FROM {{ ref('stg_TRANSFERTS') }}