docker-compose -f docker-compose-slim.yml build
docker-compose -f docker-compose-slim.yml up -d

docker-compose -f docker-compose-slim.yml exec jobmanager bash /opt/sql-client/sql-client.sh