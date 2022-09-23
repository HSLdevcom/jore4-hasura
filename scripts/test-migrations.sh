docker exec hasura bash -c "cd /tmp/hasura-project && /bin/hasura-cli migrate apply --endpoint http://localhost:8080 --admin-secret hasura --database-name default --down 10" && echo down migrations success || echo down migrations failure
docker exec hasura bash -c "cd /tmp/hasura-project && /bin/hasura-cli migrate apply --endpoint http://localhost:8080 --admin-secret hasura --database-name default --up 10" && echo up migrations success || echo up migrations failure

docker exec hasura bash -c "cd /tmp/hasura-project && /bin/hasura-cli migrate apply --endpoint http://localhost:8080 --admin-secret hasura --database-name timetables --down 2" && echo down migrations success || echo down migrations failure
docker exec hasura bash -c "cd /tmp/hasura-project && /bin/hasura-cli migrate apply --endpoint http://localhost:8080 --admin-secret hasura --database-name timetables --up 2" && echo up migrations success || echo up migrations failure
