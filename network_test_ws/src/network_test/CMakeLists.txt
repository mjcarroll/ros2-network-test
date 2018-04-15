cmake_minimum_required(VERSION 3.5)
project(network_test)

if(NOT WIN32)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -Wall -Wextra -fPIC")
endif()

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)


add_executable(network_test
  ${CMAKE_CURRENT_SOURCE_DIR}/src/main_network_test.cpp
)

ament_target_dependencies(network_test
  "rclcpp"
  "std_msgs"
)

#Install target to install/bin
install(TARGETS network_test DESTINATION bin)

ament_package()
