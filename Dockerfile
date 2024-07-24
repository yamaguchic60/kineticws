# ベースイメージとしてUbuntu 16.04を使用
FROM ubuntu:16.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive

# 必要なパッケージのインストール
RUN apt update && apt install -y \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common \
    build-essential \
    cmake \
    git \
    wget \
    vim \
    python-pip \
    python-virtualenv \
    locales \
    sudo \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# ロケールの設定
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# catkin_toolsのインストール
RUN pip install catkin_tools

# ROS Kineticのセットアップ
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
    && apt update \
    && apt install -y ros-kinetic-desktop-full \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# ROSの初期設定
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash"

# Gazeboのインストール
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" > /etc/apt/sources.list.d/gazebo-stable.list' \
    && wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add - \
    && apt update \
    && apt install -y gazebo7 \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# ROSパッケージの依存関係をインストール
RUN apt update && apt install -y \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init && rosdep update

# Pythonの深層学習ライブラリのインストール
RUN pip install --upgrade pip
RUN pip install \
    numpy \
    scipy \
    matplotlib \
    pandas \
    scikit-learn \
    tensorflow \
    torch \
    torchvision

# 作業ディレクトリの作成
WORKDIR /root/catkin_ws

# エントリーポイントの設定
CMD ["bash"]

