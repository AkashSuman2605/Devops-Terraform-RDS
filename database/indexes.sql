USE hoteldb;

-- Composite index to optimize the assessment query:
--
-- SELECT org_id, status, COUNT(*), SUM(amount)
-- FROM hotel_bookings
-- WHERE city = 'Delhi'
--   AND created_at >= NOW() - INTERVAL '30 days'
-- GROUP BY org_id, status;

CREATE INDEX idx_booking_query
ON hotel_bookings (
    city,
    created_at,
    org_id,
    status
);
