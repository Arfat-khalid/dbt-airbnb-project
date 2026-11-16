select *
from {{ ref('dim_listings_cleansed') }} as dlc
inner join {{ ref('fct_reviews') }} as fr
    on dlc.listing_id = fr.listing_id
where fr.review_date < dlc.created_at
