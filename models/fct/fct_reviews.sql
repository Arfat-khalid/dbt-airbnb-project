{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='review_id'
) }}

WITH src_reviews AS (
  SELECT * FROM {{ ref('src_reviews') }}
)
SELECT *,md5(cast(concat(listing_id, '|', review_date, '|', reviewer_name, '|', review_text) as varchar)) as review_id,
     FROM src_reviews
WHERE review_text is not null

{% if is_incremental() %}
  AND review_date > (select max(review_date) from {{ this }})
{% endif %}