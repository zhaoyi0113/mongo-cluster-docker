source ./env.sh
docker-compose -f docker-compose.1.yml -f docker-compose.2.yml -f docker-compose.3.yml -f docker-compose.cnf.yml -f docker-compose.shard.yml  up -d 
