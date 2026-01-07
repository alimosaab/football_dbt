/* Utile pour savoir si les buts sont marqués sur penalty, coup franc ou action de jeu. */
{{ config(materialized='table') }}

SELECT 
    "TYPE_BUT_ID",
    "NOM_TYPE_BUT"
FROM {{ ref('stg_TYPES_BUTS_REFERENCE') }}