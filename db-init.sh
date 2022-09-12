#!/bin/bash
apt-get update
apt-get install -y htop postgresql-all
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/13/main/postgresql.conf
echo "host all all 172.16.0.0/12 md5" >> /etc/postgresql/13/main/pg_hba.conf
pg_ctlcluster restart 13 main
sleep 5
sudo -u postgres psql <<'XXX'
CREATE DATABASE test;
CREATE ROLE test WITH LOGIN PASSWORD 'dummy';
GRANT ALL ON DATABASE test TO test;
\c test
CREATE TABLE cfg AS SELECT 'instance' AS KEY, 'db${index}' AS VAL;
GRANT ALL ON cfg TO PUBLIC;
XXX
