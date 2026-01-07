{{ config(materialized='view') }}

SELECT 
    CAST("type_but_id" AS INT) AS "TYPE_BUT_ID",
    "nom_type_but" AS "NOM_TYPE_BUT"
FROM {{ source('champions_raw', 'TYPES_BUTS_REFERENCE') }}