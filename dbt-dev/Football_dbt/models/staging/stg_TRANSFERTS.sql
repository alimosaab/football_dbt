{{ config(materialized='view') }}

SELECT 
    CAST("transfert_id" AS INT) AS "TRANSFERT_ID",
    CAST("joueur_id" AS INT) AS "JOUEUR_ID",
    CAST("entraineur_id" AS INT) AS "ENTRAINEUR_ID",
    CAST("saison_id" AS INT) AS "SAISON_ID",
    CAST("ancienne_equipe_id" AS INT) AS "ANCIENNE_EQUIPE_ID",
    CAST("nouvelle_equipe_id" AS INT) AS "NOUVELLE_EQUIPE_ID",
    "date_transfert" AS "DATE_TRANSFERT",
    CAST("montant_transfert" AS NUMERIC(15,2)) AS "MONTANT_TRANSFERT",
    "type_transfert" AS "TYPE_TRANSFERT"
FROM {{ source('champions_raw', 'TRANSFERTS') }}