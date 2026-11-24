SELECT
    distribution_channel,
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN is_canceled = 0 THEN 1 ELSE 0 END) AS completed_bookings,
    ROUND(SUM(CASE WHEN is_canceled = 0 THEN booking_revenue ELSE 0 END), 2) AS gross_revenue,
    ROUND(SUM(CASE WHEN is_canceled = 0 THEN booking_revenue * commission_rate ELSE 0 END), 2) AS commission_cost,
    ROUND(SUM(CASE WHEN is_canceled = 0 THEN booking_revenue * (1 - commission_rate) ELSE 0 END), 2) AS net_revenue,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN booking_revenue ELSE 0 END), 2) AS lost_revenue_from_cancellations
FROM (
    SELECT
        distribution_channel,
        is_canceled,
        adr * (stays_in_weekend_nights + stays_in_week_nights) AS booking_revenue,
        CASE
            WHEN distribution_channel = 'TA/TO' THEN 0.18
            WHEN distribution_channel = 'GDS' THEN 0.12
            WHEN distribution_channel = 'Corporate' THEN 0.05
            ELSE 0.00
        END AS commission_rate
    FROM bookings
    WHERE distribution_channel != 'Undefined'
) AS booking_financials
GROUP BY distribution_channel
ORDER BY net_revenue DESC;