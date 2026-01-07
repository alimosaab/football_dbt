/* Simple mais indispensable pour filtrer tes rapports par année. */
{{ config(materialized='table') }}

SELECT 
    "SAISON_ID",
    "ANNEE_DEBUT",
    "ANNEE_FIN",
    CONCAT("ANNEE_DEBUT", '-', "ANNEE_FIN") AS "NOM_SAISON"
FROM {{ ref('stg_SAISONS') }}