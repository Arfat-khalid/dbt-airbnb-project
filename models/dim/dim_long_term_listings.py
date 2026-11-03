def model(dbt, session):
    dbt.config(materialized="table")
    listings = dbt.ref("dim_listings_cleansed")

    return (listings.filter("MINIMUM_NIGHTS >= 30")
                    .select("LISTING_ID", "LISTING_NAME", "PRICE"))