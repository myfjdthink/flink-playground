docker-compose -f docker-compose-slim.yml build
docker-compose -f docker-compose-slim.yml up -d

docker-compose -f docker-compose-slim.yml exec jobmanager bash /opt/sql-client/sql-client.sh

docker-compose -f docker-compose-slim.yml exec jobmanager bash /opt/sql-client/sql-submit.sh demo/transfer_sum_balance_lookup.sql