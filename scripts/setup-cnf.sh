#!/bin/bash 

mongodb1=`ping -c 1 ${MONGO1} | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
mongodb2=`ping -c 1 ${MONGO2} | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
mongodb3=`ping -c 1 ${MONGO3} | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

port=${PORT:-27017}

echo "Waiting for startup.."
until mongo --host ${mongodb1}:${port} --eval 'quit(db.runCommand({ ping: 1 }).ok ? 0 : 2)' &>/dev/null; do
  printf '.'
  sleep 1
done

echo "Started.."

echo setup-cnf.sh time now: `date +"%T" `
mongo --host ${mongodb1}:${port} <<EOF
   var cfg = {
        "_id": "${RS}",
        configsvr: true,
        "members": [
            {
                "_id": 0,
                "host": "mongo-cnf-1:${port}"
            },
            {
                "_id": 1,
                "host": "mongo-cnf-2:${port}"
            },
            {
                "_id": 2,
                "host": "mongo-cnf-3:${port}"
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    rs.reconfig(cfg, { force: true });
EOF
