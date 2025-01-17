#!/bin/bash
NUM_NODES=6
REDIS_CLUSTER_PORT=6379
KEY_PREFIX="your-prefix-id:"
SLEEP_TIME=5
REDIS_CONTAINER_PREFIX="redis-node"

log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}
reset_redis_nodes() {
  log_message "Resetting all Redis nodes..."
  for i in $(seq 1 $NUM_NODES); do
    docker exec "$REDIS_CONTAINER_PREFIX-$i" redis-cli FLUSHALL || {
      log_message "Failed to FLUSHALL on $REDIS_CONTAINER_PREFIX-$i"; exit 1;
    }
    docker exec "$REDIS_CONTAINER_PREFIX-$i" redis-cli CLUSTER RESET || {
      log_message "Failed to RESET cluster on $REDIS_CONTAINER_PREFIX-$i"; exit 1;
    }
  done
}

wait_for_nodes() {
  log_message "Waiting for Redis nodes to start..."
  sleep $SLEEP_TIME
}

create_redis_cluster() {
  log_message "Creating Redis cluster..."
  NODE_ADDRESSES=""
  
  for i in $(seq 1 $NUM_NODES); do
    IP_ADDRESS=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$REDIS_CONTAINER_PREFIX-$i")
    NODE_ADDRESSES+="$IP_ADDRESS:$REDIS_CLUSTER_PORT "
  done
  
  docker exec "$REDIS_CONTAINER_PREFIX-1" redis-cli --cluster create \
    $NODE_ADDRESSES --cluster-replicas 1 --cluster-yes || {
      log_message "Failed to create Redis cluster"; exit 1;
    }
  
  log_message "Redis cluster created successfully."
}
add_sample_keys() {
  log_message "Creating keys with prefix: $KEY_PREFIX"
  
  for i in $(seq 1 5); do
    key="${KEY_PREFIX}${i}"
    value="value-${i}"
    
    NODE_INDEX=$((i % NUM_NODES + 1))
    log_message "Assigning key $key to $REDIS_CONTAINER_PREFIX-$NODE_INDEX"
    
    docker exec "$REDIS_CONTAINER_PREFIX-$NODE_INDEX" redis-cli -c SET "$key" "$value" || {
      log_message "Failed to set key: $key on $REDIS_CONTAINER_PREFIX-$NODE_INDEX"; exit 1;
    }
    
    log_message "Created key: $key on $REDIS_CONTAINER_PREFIX-$NODE_INDEX"
  done
}

list_keys_by_prefix() {
  local prefix=$1
  log_message "Listing all keys with prefix: $prefix"
  docker exec "$REDIS_CONTAINER_PREFIX-1" redis-cli -c KEYS "$prefix*" || {
    log_message "Failed to list keys with prefix: $prefix"; exit 1;
  }
}

delete_keys_by_prefix() {
  local prefix=$1
  log_message "Deleting all keys with prefix: $prefix"

  docker exec "$REDIS_CONTAINER_PREFIX-1" bash -c "redis-cli -c KEYS '$prefix*' | xargs -r redis-cli -c DEL" || {
    log_message "Failed to delete keys with prefix: $prefix"; exit 1;
  }

  log_message "Deletion complete!"
}

verify_key_deletion() {
  local prefix=$1
  log_message "Verifying deletion - checking remaining keys with prefix: $prefix"
  docker exec "$REDIS_CONTAINER_PREFIX-1" redis-cli -c KEYS "$prefix*" || {
    log_message "Failed to verify deletion"; exit 1;
  }
}

main() {
  reset_redis_nodes
  wait_for_nodes
  create_redis_cluster
  sleep $SLEEP_TIME  
  add_sample_keys
  list_keys_by_prefix "$KEY_PREFIX"
  delete_keys_by_prefix "$KEY_PREFIX"
  verify_key_deletion "$KEY_PREFIX"
}

main
