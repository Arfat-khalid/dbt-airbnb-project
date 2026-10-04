select * 
from {{ ref('dim_listings_cleansed') }} dlc
Join {{ ref('fct_reviews') }} fr
on dlc.listing_id = fr.listing_id 
where fr.review_date < dlc.created_at