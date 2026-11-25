SELECT
    arrival_date_year,
    month_num,
    arrival_date_month,
    completed_bookings,
    net_revenue,
    LAG(net_revenue) OVER (ORDER BY arrival_date_year, month_num) AS prev_month_net_revenue,
    ROUND(
        (net_revenue - LAG(net_revenue) OVER (ORDER BY arrival_date_year, month_num)) * 100.0
        / LAG(net_revenue) OVER (ORDER BY arrival_date_year, month_num),
        2
    ) AS mom_growth_pct
FROM (
    SELECT
        arrival_date_year,
        CASE arrival_date_month
            WHEN 'January' THEN 1
            WHEN 'February' THEN 2
            WHEN 'March' THEN 3
            WHEN 'April' THEN 4
            WHEN 'May' THEN 5
            WHEN 'June' THEN 6
            WHEN 'July' THEN 7
            WHEN 'August' THEN 8
            WHEN 'September' THEN 9
            WHEN 'October' THEN 10
            WHEN 'November' THEN 11
            WHEN 'December' THEN 12
        END AS month_num,
        arrival_date_month,
        COUNT(*) AS completed_bookings,
        ROUND(SUM(
            adr * (stays_in_weekend_nights + stays_in_week_nights) *
            CASE
                WHEN distribution_channel = 'TA/TO' THEN 0.82
                WHEN distribution_channel = 'GDS' THEN 0.88
                WHEN distribution_channel = 'Corporate' THEN 0.95
                ELSE 1.00
            END
        ), 2) AS net_revenue
    FROM bookings
    WHERE is_canceled = 0
      AND distribution_channel != 'Undefined'
    GROUP BY arrival_date_year, month_num, arrival_date_month
) AS monthly_revenue
ORDER BY arrival_date_year, month_num;