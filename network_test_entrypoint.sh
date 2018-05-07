#!/bin/bash
set -e

source "$ROS2_WS/install/prefix.bash"
source "/root/ros2/network_test_ws/install/prefix.bash"

if [ "$CMD" == "list" ]
then
  exec /root/ros2/network_test_ws/install/list_nodes/bin/list_nodes
elif [ "$CMD" == "node" ] 
then
  awk 'END{print $1}' /etc/hosts
  /root/ros2/network_test_ws/install/network_test/bin/network_test ${NODE}
else 
  exec "$@"
fi
