# kunaldevxx@DESKTOP-EGLMUK9:/mnt/wsl/docker-desktop-bind-mounts/Ubuntu/af129b6ec6d4ebbbbf235c089f9a62e82e6edce3e5cb5292f36b7bb4a2627923$ ./create_and_delete_keys.sh
# 2025-01-17 05:29:48 - Resetting all Redis nodes...
# OK
# OK
# OK
# OK
# OK
# OK
# READONLY You can't write against a read only replica.
# 
# OK
# READONLY You can't write against a read only replica.
# 
# OK
# READONLY You can't write against a read only replica.
# 
# OK
# 2025-01-17 05:29:50 - Waiting for Redis nodes to start...
# 2025-01-17 05:29:55 - Creating Redis cluster...
# >>> Performing hash slots allocation on 6 nodes...
# Master[0] -> Slots 0 - 5460
# Master[1] -> Slots 5461 - 10922
# Master[2] -> Slots 10923 - 16383
# Adding replica 172.21.0.4:6379 to 172.21.0.6:6379
# Adding replica 172.21.0.2:6379 to 172.21.0.7:6379
# Adding replica 172.21.0.5:6379 to 172.21.0.3:6379
# M: cb49ba21cdf064857bae052c07302b39bb10be64 172.21.0.6:6379
#    slots:[0-5460] (5461 slots) master
# M: e0df181f892729de21b90f4ee163b2bb1fa38e9b 172.21.0.7:6379
#    slots:[5461-10922] (5462 slots) master
# M: 8843d421e6f77d370e4d16aaf7e5a328322cc317 172.21.0.3:6379
#    slots:[10923-16383] (5461 slots) master
# S: 3ff677dd13d0bc868bec33961b83b09ee7079fc0 172.21.0.5:6379
#    replicates 8843d421e6f77d370e4d16aaf7e5a328322cc317
# S: faf350f5efbf73b96fa4d4fa317163aa9917b3bf 172.21.0.4:6379
#    replicates cb49ba21cdf064857bae052c07302b39bb10be64
# S: 6d746757b2805010f129aec0eb784539f4b20347 172.21.0.2:6379
#    replicates e0df181f892729de21b90f4ee163b2bb1fa38e9b
# >>> Nodes configuration updated
# >>> Assign a different config epoch to each node
# >>> Sending CLUSTER MEET messages to join the cluster
# Waiting for the cluster to join
# .
# >>> Performing Cluster Check (using node 172.21.0.6:6379)
# M: cb49ba21cdf064857bae052c07302b39bb10be64 172.21.0.6:6379
#    slots:[0-5460] (5461 slots) master
#    1 additional replica(s)
# S: 3ff677dd13d0bc868bec33961b83b09ee7079fc0 172.21.0.5:6379
#    slots: (0 slots) slave
#    replicates 8843d421e6f77d370e4d16aaf7e5a328322cc317
# S: 6d746757b2805010f129aec0eb784539f4b20347 172.21.0.2:6379
#    slots: (0 slots) slave
#    replicates e0df181f892729de21b90f4ee163b2bb1fa38e9b
# S: faf350f5efbf73b96fa4d4fa317163aa9917b3bf 172.21.0.4:6379
#    slots: (0 slots) slave
#    replicates cb49ba21cdf064857bae052c07302b39bb10be64
# M: 8843d421e6f77d370e4d16aaf7e5a328322cc317 172.21.0.3:6379
#    slots:[10923-16383] (5461 slots) master
#    1 additional replica(s)
# M: e0df181f892729de21b90f4ee163b2bb1fa38e9b 172.21.0.7:6379
#    slots:[5461-10922] (5462 slots) master
#    1 additional replica(s)
# [OK] All nodes agree about slots configuration.
# >>> Check for open slots...
# >>> Check slots coverage...
# [OK] All 16384 slots covered.
# 2025-01-17 05:29:57 - Redis cluster created successfully.
# 2025-01-17 05:30:02 - Creating keys with prefix: your-prefix-id:
# 2025-01-17 05:30:02 - Assigning key your-prefix-id:1 to redis-node-2
# OK
# 2025-01-17 05:30:02 - Created key: your-prefix-id:1 on redis-node-2
# 2025-01-17 05:30:03 - Assigning key your-prefix-id:2 to redis-node-3
# OK
# 2025-01-17 05:30:03 - Created key: your-prefix-id:2 on redis-node-3
# 2025-01-17 05:30:03 - Assigning key your-prefix-id:3 to redis-node-4
# OK
# 2025-01-17 05:30:03 - Created key: your-prefix-id:3 on redis-node-4
# 2025-01-17 05:30:03 - Assigning key your-prefix-id:4 to redis-node-5
# OK
# 2025-01-17 05:30:03 - Created key: your-prefix-id:4 on redis-node-5
# 2025-01-17 05:30:03 - Assigning key your-prefix-id:5 to redis-node-6
# OK
# 2025-01-17 05:30:03 - Created key: your-prefix-id:5 on redis-node-6
# 2025-01-17 05:30:03 - Assigning key your-prefix-id:6 to redis-node-1
# OK
# 2025-01-17 05:30:03 - Created key: your-prefix-id:6 on redis-node-1
# 2025-01-17 05:30:03 - Assigning key your-prefix-id:7 to redis-node-2
# OK
# 2025-01-17 05:30:03 - Created key: your-prefix-id:7 on redis-node-2
# 2025-01-17 05:30:03 - Assigning key your-prefix-id:8 to redis-node-3
# OK
# 2025-01-17 05:30:03 - Created key: your-prefix-id:8 on redis-node-3
# 2025-01-17 05:30:03 - Assigning key your-prefix-id:9 to redis-node-4
# OK
# 2025-01-17 05:30:04 - Created key: your-prefix-id:9 on redis-node-4
# 2025-01-17 05:30:04 - Assigning key your-prefix-id:10 to redis-node-5
# OK
# 2025-01-17 05:30:04 - Created key: your-prefix-id:10 on redis-node-5
# 2025-01-17 05:30:04 - Listing all keys with prefix: your-prefix-id:
# 
# your-prefix-id:1
# your-prefix-id:1
# your-prefix-id:10
# your-prefix-id:10
# your-prefix-id:2
# your-prefix-id:2
# your-prefix-id:3
# your-prefix-id:3
# your-prefix-id:4
# your-prefix-id:4
# your-prefix-id:5
# your-prefix-id:5
# your-prefix-id:6
# your-prefix-id:6
# your-prefix-id:7
# your-prefix-id:7
# your-prefix-id:8
# your-prefix-id:8
# your-prefix-id:9
# your-prefix-id:9
# 2025-01-17 05:30:04 - Listed all keys with prefix: your-prefix-id:
# 2025-01-17 05:30:04 - Deleting keys with prefix: your-prefix-id:
# Could not connect to Redis at redis-node-1:6379: Name or service not known
# 2025-01-17 05:30:09 - Deleting key your-prefix-id:6 on redis-node-1
# 1
# 2025-01-17 05:30:09 - Deleted key: your-prefix-id:6 on redis-node-1
# Could not connect to Redis at redis-node-1:6379: Name or service not known
# 2025-01-17 05:30:13 - Deleting key your-prefix-id:2 on redis-node-1
# 1
# 2025-01-17 05:30:13 - Deleted key: your-prefix-id:2 on redis-node-1
# 2025-01-17 05:30:13 - Verifying deletion - checking remaining keys with prefix: your-prefix-id:
# 2025-01-17 05:30:13 - All keys with prefix: your-prefix-id: successfully deleted.