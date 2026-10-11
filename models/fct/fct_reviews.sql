{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='review_id'
) }}

WITH src_reviews AS (
  SELECT * FROM {{ ref('src_reviews') }}
)
SELECT {{ dbt_utils.generate_surrogate_key(['listing_id', 'review_date', 'reviewer_name', 'review_text']) }}
    AS review_id, *
     FROM src_reviews
WHERE review_text is not null

{% if is_incremental() %}
  AND review_date > (select max(review_date) from {{ this }})
{% endif %}