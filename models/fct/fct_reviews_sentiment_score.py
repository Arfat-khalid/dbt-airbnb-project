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
    fct_reviews_sentiment_score = dbt.ref("fct_reviews")
    fct_reviews_sentiment_score_df = fct_reviews_sentiment_score.df()

    # Calculate sentiment score based on review text
    fct_reviews_sentiment_score_df["SENTIMENT_SCORE"] = fct_reviews_sentiment_score_df["review_text"].apply(get_sentiment_score)

    # return final dataset (Pandas DataFrame)
    return fct_reviews_sentiment_score_df