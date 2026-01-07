/* Cette table va regrouper les informations des équipes avec le nom du stade.*/
{{ config(materialized='table') }}

WITH equipes AS (
    SELECT * FROM {{ ref('stg_EQUIPES') }}
),

stades AS (
    SELECT * FROM {{ ref('stg_STADES') }}
)

SELECT 
    e."EQUIPE_ID",
    e."NOM_EQUIPE",
    e."CODE_FIFA",
    e."VILLE",
    e."PAYS",
    s."NOM_STADE",
    s."CAPACITE"
FROM equipes e
LEFT JOIN stades s ON e."STADE_ID" = s."STADE_ID"