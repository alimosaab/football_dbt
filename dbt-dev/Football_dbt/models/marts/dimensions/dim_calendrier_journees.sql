/* Celle-ci est cruciale car elle lie les saisons aux numéros de journées. */
{{ config(materialized='table') }}

WITH journees AS (
    SELECT * FROM {{ ref('stg_JOURNEES') }}
),
saisons AS (
    SELECT * FROM {{ ref('stg_SAISONS') }}
)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['j."SAISON_ID"', 'j."NUMERO_JOURNEE"']) }} AS "JOURNEE_KEY",
    j."SAISON_ID",
    s."ANNEE_DEBUT",
    s."ANNEE_FIN",
    j."NUMERO_JOURNEE",
    j."DATE_LIMITE"
FROM journees j
JOIN saisons s ON j."SAISON_ID" = s."SAISON_ID"

/*
(Note : Ici j'ai utilisé une "Surrogate Key" car une journée est définie par sa saison + son numéro.
 Si tu n'as pas dbt_utils, on peut faire un simple CONCAT.)
 */