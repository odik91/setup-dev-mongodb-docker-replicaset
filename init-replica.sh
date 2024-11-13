#!/bin/bash
set -e

# Start MongoDB
mongod --replSet myReplicaSet --bind_ip_all &

# Wait for MongoDB to start
until mongo --eval "print(\"waiting for connection...\")"
do
  sleep 2
done

# Check if the replica set is already initialized
rs_status=$(mongo --quiet --eval "rs.status().ok")

if [ "$rs_status" != "1" ]; then
  echo "Initializing replica set..."
  mongo --eval 'rs.initiate({
    _id: "myReplicaSet",
    members: [
      { _id: 0, host: "mongo1:27017", priority: 2 },
      { _id: 1, host: "mongo2:27017", priority: 1 },
      { _id: 2, host: "mongo3:27017", priority: 1 }
    ]
  })'
else
  echo "Replica set already initialized."
fi

# Keep container running
tail -f /dev/null
