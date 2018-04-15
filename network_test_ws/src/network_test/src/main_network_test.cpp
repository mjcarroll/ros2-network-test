#include <chrono>
#include <memory>
#include <iostream>
#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/string.hpp>

void sub_callback(std_msgs::msg::String::SharedPtr msg)
{
  std::cout << " Received: " << msg->data << std::endl;
}

int main(int argc, char *argv[])
{
  rclcpp::init(argc, argv);
  auto node = std::make_shared<rclcpp::Node>(std::string("Node" + std::string(argv[1])));
  auto pub = node->create_publisher<std_msgs::msg::String>("network_test", rmw_qos_profile_default);
  auto sub = node->create_subscription<std_msgs::msg::String>("network_test", &sub_callback, rmw_qos_profile_default);

  rclcpp::WallRate loop_rate(0.1);
  while(rclcpp::ok())
  {
    rclcpp::spin_some(node);

    auto time =std::chrono::system_clock::to_time_t( std::chrono::system_clock::now());
    std_msgs::msg::String msg;
    msg.data = std::string(node->get_name()) + " " + std::ctime(&time);
    pub->publish(msg);

    std::cout <<"Publishing: " << msg.data << std::endl;
    loop_rate.sleep();
  }

  return 0;
}
