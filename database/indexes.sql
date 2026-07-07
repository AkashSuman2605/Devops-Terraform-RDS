USE hoteldb;

-- Index for searching bookings by city
CREATE INDEX idx_city
ON hotel_bookings(city);

-- Index for searching bookings by organization
CREATE INDEX idx_org
ON hotel_bookings(org_id);

-- Index for searching bookings by status
CREATE INDEX idx_status
ON hotel_bookings(status);

-- Index for searching bookings by creation date
CREATE INDEX idx_created_at
ON hotel_bookings(created_at);
