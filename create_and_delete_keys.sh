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
    for attempt in {1..3}; do
      if docker exec "$REDIS_CONTAINER_PREFIX-$i" redis-cli FLUSHALL; then
        break
      fi
      sleep 1
    done
    for attempt in {1..3}; do
      if docker exec "$REDIS_CONTAINER_PREFIX-$i" redis-cli CLUSTER RESET; then
        break
      fi
      sleep 1
    done
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
  NUM_KEYS=10 

  for i in $(seq 1 $NUM_KEYS); do
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
  local prefix="$1"
  log_message "Listing all keys with prefix: $prefix"
  
  # Use sort -u to deduplicate keys
  for i in $(seq 1 $NUM_NODES); do
    node_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$REDIS_CONTAINER_PREFIX-$i")
    docker exec "$REDIS_CONTAINER_PREFIX-$i" redis-cli -h "$node_ip" -c KEYS "$prefix*" 2>/dev/null
  done | sort -u
  
  log_message "Listed all keys with prefix: $prefix"
}

check_node_health() {
  for i in $(seq 1 $NUM_NODES); do
    node_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$REDIS_CONTAINER_PREFIX-$i")
    if ! docker exec "$REDIS_CONTAINER_PREFIX-$i" redis-cli -h "$node_ip" ping; then
      log_message "Node $REDIS_CONTAINER_PREFIX-$i ($node_ip) is not responsive!"
      exit 1
    fi
  done
}

delete_sample_keys() {
  log_message "Deleting keys with prefix: $KEY_PREFIX"
  
  keys=""
  for i in $(seq 1 $NUM_NODES); do
    node_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$REDIS_CONTAINER_PREFIX-$i")
    keys+=$(docker exec "$REDIS_CONTAINER_PREFIX-$i" redis-cli -h "$node_ip" -c KEYS "$KEY_PREFIX*")" "
  done
  for key in $keys; do
    node_info=$(docker exec "$REDIS_CONTAINER_PREFIX-1" redis-cli -c CLUSTER KEYSLOT "$key")
    node_index=$((node_info % NUM_NODES + 1))
    node_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$REDIS_CONTAINER_PREFIX-$node_index")
    
    log_message "Deleting key $key on $REDIS_CONTAINER_PREFIX-$node_index ($node_ip)"
    docker exec "$REDIS_CONTAINER_PREFIX-$node_index" redis-cli -h "$node_ip" -c DEL "$key" || {
      log_message "Failed to delete key: $key on $REDIS_CONTAINER_PREFIX-$node_index"; exit 1;
    }
    log_message "Deleted key: $key on $REDIS_CONTAINER_PREFIX-$node_index"
  done
}


verify_key_deletion() {
  local prefix=$1
  log_message "Verifying deletion - checking remaining keys with prefix: $prefix"
  
  REMAINING_KEYS=""
  for i in $(seq 1 $NUM_NODES); do
    node_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$REDIS_CONTAINER_PREFIX-$i")
    REMAINING_KEYS+=$(docker exec "$REDIS_CONTAINER_PREFIX-$i" redis-cli -h "$node_ip" -c KEYS "$prefix*")" "
  done

  if [[ -z "$REMAINING_KEYS" ]]; then
    log_message "All keys with prefix: $prefix successfully deleted."
  else
    log_message "Remaining keys: $REMAINING_KEYS"
    exit 1
  fi
}


main() {
  reset_redis_nodes
  wait_for_nodes
  create_redis_cluster
  sleep $SLEEP_TIME  
  add_sample_keys
  check_node_health
  list_keys_by_prefix "$KEY_PREFIX"
  delete_sample_keys "$KEY_PREFIX"
  verify_key_deletion "$KEY_PREFIX"
}

main
