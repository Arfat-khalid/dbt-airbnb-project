import holidays


def is_holiday(date_col):
    german_holidays = holidays.Germany()
    is_holiday = (date_col in german_holidays)
    return is_holiday

def model(dbt, session):
    dbt.config(
        materialized = "table"
    )

    full_moon_dates = dbt.ref("seed_full_moon_dates")

    full_moon_df = full_moon_dates.df()

    full_moon_df["IS_HOLIDAY"] = full_moon_df["full_moon_date"].apply(is_holiday)

    # return final dataset (Pandas DataFrame)
    return full_moon_df