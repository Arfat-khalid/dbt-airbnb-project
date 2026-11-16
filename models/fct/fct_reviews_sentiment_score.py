from textblob import TextBlob

def get_sentiment_score(review_text):
    if review_text is None:
        return 0.0
    blob = TextBlob(review_text)
    return blob.sentiment.polarity


def model(dbt, session):
    dbt.config(
        materialized = "table"
        
    )
    reviews = dbt.ref("fct_reviews")
    reviews_df = reviews.df()

    # Calculate sentiment score based on review text
    reviews_df["SENTIMENT_SCORE"] = reviews_df["review_text"].apply(get_sentiment_score)

    # return final dataset (Pandas DataFrame)
    return reviews_df