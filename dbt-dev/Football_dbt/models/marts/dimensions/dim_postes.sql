/* Pour pouvoir filtrer les performances par ligne (Attaque, Milieu, etc.). */
{{ config(materialized='table') }}

SELECT 
    "POSTE_ID",
    "NOM_POSTE"
FROM {{ ref('stg_POSTES_REFERENCE') }}