import holidays


def is_holiday(date_col):
    german_holidays = holidays.Germany()
    is_holiday = (date_col in german_holidays)
    return is_holiday

def model(dbt, session):
    dbt.config(
        materialized = "table",
        packages = ["holidays"]
    )

    orders_df = dbt.ref("seed_full_moon_dates")

    df = orders_df.df()

    df["IS_HOLIDAY"] = df["full_moon_date"].apply(is_holiday)

    # return final dataset (Pandas DataFrame)
    return df