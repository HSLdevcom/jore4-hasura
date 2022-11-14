---------- Journey Pattern ----------

DROP TABLE journey_pattern.scheduled_stop_point_in_journey_pattern CASCADE;
DROP TABLE journey_pattern.journey_pattern CASCADE;

---------- Service Pattern ----------

DROP TABLE service_pattern.vehicle_mode_on_scheduled_stop_point CASCADE;
DROP TABLE service_pattern.scheduled_stop_point CASCADE;
DROP TABLE service_pattern.scheduled_stop_point_invariant CASCADE;

---------- Timing Pattern ----------

DROP TABLE timing_pattern.timing_place CASCADE;

---------- Route ----------

DROP TABLE route.infrastructure_link_along_route CASCADE;
DROP TABLE route.route CASCADE;
DROP TABLE route.line CASCADE;
DROP TABLE route.type_of_line CASCADE;
DROP TABLE route.direction CASCADE;

---------- Infrastructure Network ----------

DROP TABLE infrastructure_network.vehicle_submode_on_infrastructure_link CASCADE;
DROP TABLE infrastructure_network.infrastructure_link CASCADE;
DROP TABLE infrastructure_network.direction CASCADE;
DROP TABLE infrastructure_network.external_source CASCADE;

---------- Reusable Components ----------

DROP TABLE reusable_components.vehicle_submode CASCADE;
DROP TABLE reusable_components.vehicle_mode CASCADE;
