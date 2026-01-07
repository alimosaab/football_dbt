/* Même si les stades sont dans la dimension équipes, il est utile d'avoir une dimension propre 
pour analyser les affluences ou les capacités par pays.*/
{{ config(materialized='table') }}

SELECT 
    "STADE_ID",
    "NOM_STADE",
    "VILLE_STADE" AS "VILLE",
    "PAYS_STADE" AS "PAYS",
    "CAPACITE"
FROM {{ ref('stg_STADES') }}