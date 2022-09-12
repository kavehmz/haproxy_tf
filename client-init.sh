#!/bin/bash
apt-get update
apt-get install -y htop postgresql-all
install -o admin -g admin -m 0600 /dev/null .pgpass
sudo -u admin tee ~admin/.pgpass <<<'*:*:test:test:dummy'
