cmake_minimum_required(VERSION 3.5)
project(list_nodes)

if(NOT WIN32)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -Wall -Wextra -fPIC")
endif()

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rcutils REQUIRED)
find_package(rmw REQUIRED)


add_executable(list_nodes
  ${CMAKE_CURRENT_SOURCE_DIR}/src/list_nodes.cpp
)

ament_target_dependencies(list_nodes
  "rclcpp"
  "rcutils"
)

#Install target to install/bin
install(TARGETS list_nodes DESTINATION bin)

ament_package()
