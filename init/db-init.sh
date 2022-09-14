#!/bin/bash
apt-get update
apt-get install -y htop postgresql-all
echo "host all all 172.16.0.0/12 md5" >> /etc/postgresql/13/main/pg_hba.conf
sudo -u postgres psql <<'XXX'
ALTER SYSTEM SET listen_addresses = '*';
ALTER SYSTEM SET max_connections = 2000;
ALTER SYSTEM SET tcp_keepalives_count = 10;
ALTER SYSTEM SET tcp_keepalives_interval = 2;
ALTER SYSTEM SET tcp_keepalives_idle = 30;
ALTER SYSTEM SET tcp_user_timeout = '30s';

CREATE DATABASE test;
CREATE ROLE test WITH LOGIN PASSWORD 'dummy';
GRANT ALL ON DATABASE test TO test;
\c test
CREATE TABLE cfg AS SELECT 'instance' AS KEY, 'db${index}' AS VAL;
GRANT ALL ON cfg TO PUBLIC;
XXX
systemctl restart postgresql@13-main
sleep 5
