CREATE OR REPLACE TABLE bookings AS
SELECT * FROM read_csv_auto(
    'C:/Users/lashi/OneDrive/Documents/uk-revenue-channel-analytics/data/hotel_bookings.csv',
    nullstr = ['NA', 'NULL']
);

SELECT COUNT(*) AS total_rows
FROM bookings;

SELECT *
FROM bookings
LIMIT 10;

SELECT
    distribution_channel,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    ROUND(SUM(is_canceled) * 100.0 / COUNT(*), 2) AS cancellation_rate_pct,
    ROUND(AVG(adr), 2) AS avg_daily_rate
FROM bookings
GROUP BY distribution_channel
ORDER BY total_bookings DESC;