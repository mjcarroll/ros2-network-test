# ros2-network-test
Simple container setup to reproduce some issues with ros2.

This repo contains a [sample node](network_test_ws/src/network_test)
and a simple [script](setup-container.sh) to run multiple connected nspawn-containers, with one sample node running
in each container.

There is also a [node](network_test_ws/src/list_nodes) to list all found nodes using
`node->get_node_graph_interface()->get_node_names()` because the ros2cli tool does not work for me
in nspawn-containers.

## Requirements
To directly use the provided script, you need a linux-system with a btrfs-filesystem, systemd, and screen installed. Otherwise you
will need to do it some other way.

## Usage
First, you need to set up a template nspawn-container at `/var/lib/machines/networktest-template` as a btrfs-subvolume:
- Create subvolume: `# btrfs subvolume create /var/lib/machines/networktest-template`
- [Setup an environment](https://wiki.archlinux.org/index.php/Systemd-nspawn#Create_a_Debian_or_Ubuntu_environment) (I used Ubuntu xenial) and install ros2 dependencies
- Start container with bound ros2_ws and network_test_ws: `# systemd-nspawn --bind=<your ros2_ws> --bind=<your network_test_ws> -bM networktest-template`
- Build ros2 and network_test if not done already, so they are 
- Install `network_test.service` at `/etc/systemd/system/` in container, and adjust paths in it
- Enable `network_test.service` and `systemd-networkd.service` in container: `# systemctl enable network_test systemd-networkd`
- Stop the template container

Now you can create the containers which are used for testing: `# bash setup-container.sh setup`
This creates 20 containers numbered from 10 to 29, called rostestN.

`# bash setup-container.sh run` actually runs the test. This will start each container in its own screen session, with the same name as the container.
To see the issue, attach to a screen session, login, source local_setup.bash and list the nodes using the provided `list_nodes | sort` node. Some nodes will be missing.
To check the output of the sample node, run: `# journalctl -r _SYSTEMD_UNIT=network_test.service`. You probably want to compare the output
of different containers.

Since the problem does not always occur, you might need to stop `# bash setup-container.sh stop` and restart again a few times.



