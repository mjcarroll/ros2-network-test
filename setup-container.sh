#!/bin/bash

# Usage: sudo bash setup-container.sh {setup|run|stop|clean}
# Requires a btrfs filesystem, systemd and screen
#
# Expects a set up container template at /var/lib/machines/networktest-template as subvolume
# which has all ros2 dependencies installed, systemd-networkd enabled, and the template service
# file network_test.service installed and enabled.
#
# Adjust ros2 and debug workspace locations here
ros2_ws=/home/ralino/fzi/ros2_ws
network_test_ws=/home/ralino/fzi/network_test/network_test_ws

case "$1" in
  "setup")
    template="/var/lib/machines/networktest-template"
    systemctl start systemd-networkd.service # Required for nspawns network-zone
    for n in {1..5}; do
      root="/var/lib/machines/rostest$n"
      btrfs subvolume snapshot $template $root
      echo "rostest$n" > $root/etc/hostname
      sed -i "s/1234/${n}/" $root/etc/systemd/system/network_test.service
    done
    ;;
  "run")
    for n in {1..5}; do
      screen -d -m -S rostest$n systemd-nspawn --network-zone=roszone --bind-ro="$ros2_ws" --bind-ro="$network_test_ws" -b -D /var/lib/machines/rostest$n
      echo "Started rostest$n"
      sleep 1
    done
    ;;
  "stop")
    for n in {1..5}; do
      machinectl stop rostest$n
      echo "Stopped rostest$n"
      sleep 1
    done
    ;;
  "clean")
    for n in {1..5}; do
      machinectl terminate rostest$n
      screen -D rostest$n
      sleep 1
    done
    sleep 1
    for n in {1..5}; do
      root="/var/lib/machines/rostest$n"
      btrfs subvolume delete $root
    done
    screen -wipe
    ;;
  *)
    echo "unknown argument"
    exit 1
    ;;
esac
