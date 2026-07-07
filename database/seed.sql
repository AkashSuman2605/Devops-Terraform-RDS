USE hoteldb;

DELIMITER $$

CREATE PROCEDURE seed_bookings()
BEGIN

    DECLARE i INT DEFAULT 1;

    WHILE i <= 100 DO

        INSERT INTO hotel_bookings
        (
            id,
            org_id,
            hotel_id,
            city,
            checkin_date,
            checkout_date,
            amount,
            status,
            created_at
        )

        VALUES
        (

            UUID(),

            UUID(),

            CONCAT('HOTEL-', FLOOR(1 + RAND()*20)),

            ELT(
                FLOOR(1 + RAND()*6),
                'Delhi',
                'Mumbai',
                'Bengaluru',
                'Hyderabad',
                'Chennai',
                'Pune'
            ),

            CURDATE(),

            DATE_ADD(CURDATE(), INTERVAL FLOOR(1 + RAND()*5) DAY),

            ROUND(1000 + RAND()*24000,2),

            ELT(
                FLOOR(1 + RAND()*4),
                'CREATED',
                'CONFIRMED',
                'COMPLETED',
                'CANCELLED'
            ),

            NOW() - INTERVAL FLOOR(RAND()*30) DAY

        );

        SET i = i + 1;

    END WHILE;

END $$

DELIMITER ;

CALL seed_bookings();

DROP PROCEDURE seed_bookings();
