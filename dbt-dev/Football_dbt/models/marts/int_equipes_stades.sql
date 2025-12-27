{{config(materialized='table') }}
WITH equipes AS (
    SELECT * FROM {{ ref('stg_EQUIPES') }}
),

stades AS (
    SELECT * FROM {{ ref('stg_STADES') }}
)

SELECT 
    e.EQUIPE_ID AS EQUIPE_ID,
    e.NOM_EQUIPE AS NOM_EQUIPE,
    e.CODE_FIFA AS CODE_FIFA,
    s.NOM_STADE AS NOM_STADE,
    s.CAPACITE  AS CAPACITE
FROM equipes e
LEFT JOIN stades s ON e.stade_id = s.STADE_ID