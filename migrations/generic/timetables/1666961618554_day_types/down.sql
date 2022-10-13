DROP TABLE service_calendar.day_type_active_on_day_of_week;
DELETE FROM service_calendar.day_type WHERE label IN ('MA','TI','KE','TO');
