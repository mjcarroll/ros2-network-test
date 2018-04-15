#include <rclcpp/rclcpp.hpp>
#include <memory>
#include <iostream>

int main(int argc, char *argv[])
{
  rclcpp::init(argc, argv);
  auto node = std::make_shared<rclcpp::Node>("list_nodes");
  // Wait for ros2 to initialize
  std::this_thread::sleep_for(std::chrono::seconds(2));
  rclcpp::spin_some(node);
  auto node_list = node->get_node_graph_interface()->get_node_names();
  for (auto & n : node_list)
  {
    std::cout << n << std::endl;
  }
}
