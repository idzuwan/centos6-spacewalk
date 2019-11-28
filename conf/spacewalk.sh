#!/bin/bash
if ! [ -f "/opt/.spacewalk_initialized" ]; then
    spacewalk-setup --non-interactive --answer-file=/opt/answer.txt
    sleep 5
    touch /opt/.spacewalk_initialized
else
	spacewalk-service start
fi
sed -i 's/shared_buffers = 384MB/shared_buffers = 100MB/g' /var/lib/pgsql/data/postgresql.conf
sysctl -w kernel.shmmax=134217728 > /dev/null
exit 0
