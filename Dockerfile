FROM osrf/ros:melodic-desktop-full-bionic

LABEL maintainer="Thomas Peyrucain <thomas.peyrucain@pal-robotics.com>"

ARG REPO_WS=/tiago_base_family_public_ws
RUN mkdir -p $REPO_WS/src
WORKDIR $REPO_WS

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    libv4l-dev \
    libv4l2rds0 \
    git \
    wget \
    vim \
    locales \
    dpkg \
    ssh \
    curl \
    aptitude \
    g++ \
    gcc \
    openvpn \
    gnupg \
    bash-completion \
    vim-gnome \
    nano \
    psmisc \
    ccache \
    gdb \
    qtcreator \
    htop \
    man \
    meld \
    silversearcher-ag \
    terminator \
    tig \
    valgrind \
    iputils-ping \
    ipython \
    python-scipy \
    python-wstool \
    python-networkx \
    python-pip  \
    python3-vcstool \
    python-rosinstall \
    python-catkin-tools \
  && rm -rf /var/lib/apt/lists/* \
  && wget https://raw.githubusercontent.com/pal-robotics/pmb2_tutorials/kinetic-devel/pmb2_public-melodic.rosinstall \
  && wget https://raw.githubusercontent.com/pal-robotics/omni_base_tutorials/master/omni_base_public-melodic.rosinstall \
  && vcs import src < pmb2_public-melodic.rosinstall \
  && vcs import src < omni_base_public-melodic.rosinstall

ARG ROSDEP_IGNORE="pal_gazebo_plugins speed_limit_node sensor_to_cloud pmb2_rgbd_sensors pal_vo_server pal_karto pal_usb_utils pal_local_planner pal_filters hokuyo_node rrbot_launch robot_pose pal_pcl rviz_plugin_covariance pal-orbbec-openni2 slam_toolbox omni_drive_controller"

RUN apt-get update && rosdep install --from-paths src --ignore-src -y --rosdistro melodic --skip-keys="${ROSDEP_IGNORE}"


RUN bash -c "source /opt/ros/melodic/setup.bash \
  && catkin build -DCATKIN_ENABLE_TESTING=0 -j $(expr `nproc` / 2) \
  && echo 'source $REPO_WS/devel/setup.bash' >> ~/.bashrc"

ENTRYPOINT ["bash"]
