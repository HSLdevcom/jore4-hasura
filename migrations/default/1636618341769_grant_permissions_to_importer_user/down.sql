REVOKE SELECT ON ALL TABLES IN SCHEMA service_pattern FROM dbimporter;
REVOKE INSERT ON ALL TABLES IN SCHEMA service_pattern FROM dbimporter;
REVOKE UPDATE ON ALL TABLES IN SCHEMA service_pattern FROM dbimporter;
REVOKE DELETE ON ALL TABLES IN SCHEMA service_pattern FROM dbimporter;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA service_pattern FROM dbimporter;

REVOKE SELECT ON ALL TABLES IN SCHEMA journey_pattern FROM dbimporter;
REVOKE INSERT ON ALL TABLES IN SCHEMA journey_pattern FROM dbimporter;
REVOKE UPDATE ON ALL TABLES IN SCHEMA journey_pattern FROM dbimporter;
REVOKE DELETE ON ALL TABLES IN SCHEMA journey_pattern FROM dbimporter;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA journey_pattern FROM dbimporter;

REVOKE SELECT ON ALL TABLES IN SCHEMA internal_service_pattern FROM dbimporter;
REVOKE INSERT ON ALL TABLES IN SCHEMA internal_service_pattern FROM dbimporter;
REVOKE UPDATE ON ALL TABLES IN SCHEMA internal_service_pattern FROM dbimporter;
REVOKE DELETE ON ALL TABLES IN SCHEMA internal_service_pattern FROM dbimporter;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA internal_service_pattern FROM dbimporter;

REVOKE SELECT ON ALL TABLES IN SCHEMA internal_route FROM dbimporter;
REVOKE INSERT ON ALL TABLES IN SCHEMA internal_route FROM dbimporter;
REVOKE UPDATE ON ALL TABLES IN SCHEMA internal_route FROM dbimporter;
REVOKE DELETE ON ALL TABLES IN SCHEMA internal_route FROM dbimporter;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA internal_route FROM dbimporter;

REVOKE SELECT ON ALL TABLES IN SCHEMA route FROM dbimporter;
REVOKE INSERT ON ALL TABLES IN SCHEMA route FROM dbimporter;
REVOKE UPDATE ON ALL TABLES IN SCHEMA route FROM dbimporter;
REVOKE DELETE ON ALL TABLES IN SCHEMA route FROM dbimporter;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA route FROM dbimporter;