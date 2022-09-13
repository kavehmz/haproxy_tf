#!/bin/bash
apt-get update
apt-get install -y htop postgresql-all
install -o admin -g admin -m 0600 /dev/stdin ~admin/.pgpass <<EOF
*:*:test:test:dummy
EOF
install -o admin -g admin -m 0644 /dev/stdin ~admin/.pg_service.conf <<EOF
[db1]
host=${db1_ip}
port=5432
user=test
dbname=test

[db2]
host=${db2_ip}
port=5432
user=test
dbname=test
EOF

cat >>~admin/.bashrc <<EOF
export DB1='-h ${db1_ip} -U test test'
export DB2='-h ${db2_ip} -U test test'
export LBEXT='-h ${lb_ext_ip} -U test test'
export LBINT='-h ${lb_int_ip} -U test test'
EOF

install -o admin -g admin -m 0755 /dev/stdin ~admin/bench.sh <<'EOF'
#!/bin/bash
pgbench <<<'select val from cfg' -c1 -n -f /dev/stdin -l "$@"
EOF

install -o admin -g admin -m 0755 /dev/stdin ~admin/switch.sh <<'EOF'
#!/bin/bash

declare -A map
map[db1]=${db1_ip}
map[db2]=${db2_ip}

ip=$${map[$1]}

[ "$ip" ] || {
    echo >&2 "$1 not found."
    echo >&2 "Please choose one of $${!map[@]}"
    exit 1
}

socat STDIO unix:/run/haproxy-master.sock <<XXX
@1 set server pg_binding/db addr $ip
XXX
EOF
