# note: we intentionally don't roll back the before_migrate hook as it would anyway "drop" everything. Instead
# we roll back everything until that and see if the "up" migrations still work

set -eu

echo "testing network database down migrations:"
docker exec hasura bash -c "cd /tmp/hasura-project && /bin/hasura-cli migrate apply --endpoint http://localhost:8080 --admin-secret hasura --database-name default --goto 1000000000000"
echo "testing network database up migrations:"
docker exec hasura bash -c "cd /tmp/hasura-project && /bin/hasura-cli migrate apply --endpoint http://localhost:8080 --admin-secret hasura --database-name default --up all"

echo "testing timetables database down migrations:"
docker exec hasura bash -c "cd /tmp/hasura-project && /bin/hasura-cli migrate apply --endpoint http://localhost:8080 --admin-secret hasura --database-name timetables --goto 1000000000000"
echo "testing timetables database up migrations:"
docker exec hasura bash -c "cd /tmp/hasura-project && /bin/hasura-cli migrate apply --endpoint http://localhost:8080 --admin-secret hasura --database-name timetables --up all"
