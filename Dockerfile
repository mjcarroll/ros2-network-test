FROM ros2:source

ADD ./network_test_ws /root/ros2/network_test_ws
WORKDIR /root/ros2/network_test_ws

RUN . /root/ros2/ros2_ws/install/prefix.sh && \
    . /root/ros2/colcon/install/prefix.sh && colcon \
    build \
    --symlink-install \
    --event-handler console_cohesion+
    
COPY ./network_test_entrypoint.sh /
ENTRYPOINT ["/network_test_entrypoint.sh"]
CMD ["bash"]

