
CREATE TABLE tour_stops (
stop_id SERIAL,
name VARCHAR(100),
start_time TIME,
end_time TIME
);



INSERT INTO tour_stops (name, start_time, end_time) VALUES 
('Touring Smart Gallery', '10:00', '11:00'),
('Lakeside Bike Ride','9:00','10:30'),
('Water-skiing at Lake','9:00','10:30'),
('Paddleboarding','10:00','12:00'),
('Wakeboarding', '10:00','12:00'),
('City Centre Bike Ride','9:00','10:30'),
('5km Bike Ride','9:00','10:30'),
('Arena Tour','14:00','16:00'),
('Lunch at Skye Tower','12:30','13:30'),
('Lunch at Taco Truck','12:00','13:00'),
('Poetry Slam', '16:00', '17:00'),
('Escape Room', '15:00', '17:30'),
('Morning Yoga in Park', '08:00', '08:30'),
('Evening Yoga', '17:00', '17:30'),
('Zoo', '13:00', '15:00'),
('Aquarium', '13:30', '15:00'),
('Coffee at Neo Cafe', '08:30', '09:00'),
('Wine Tasting', '16:00', '17:00')
Returning *;

WITH RECURSIVE stg as (

SELECT start_time
  , end_time
  , concat('>> ' , name, ' ', start_time, ' - ', end_time) as activity_plan
FROM tour_stops
WHERE stop_id = 14

UNION ALL

SELECT t.start_time
  , t.end_time
  , concat(stg.activity_plan, '>> ', t.name, ' ', t.start_time, ' - ', t.end_time) as activity_plan 
FROM stg
INNER JOIN tour_stops t on t.start_time > stg.end_time
)

SELECT activity_plan
FROM stg
WHERE  end_time > '15:00' 
and activity_plan like '%Lunch%'
order by Length(activity_plan) DESC;
