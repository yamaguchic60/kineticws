# ベースイメージとしてUbuntu 16.04を使用
FROM ubuntu:16.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive

# 基本的なパッケージのインストール
RUN apt update
RUN apt upgrade -y
RUN apt install -y curl
RUN apt install -y gnupg2
RUN apt install -y lsb-release
RUN apt install -y software-properties-common
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

# 開発ツールのインストール
RUN apt update
RUN apt install -y build-essential
RUN apt install -y cmake
RUN apt install -y git
RUN apt install -y wget
RUN apt install -y vim
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

# Python2.7と関連パッケージのインストール
RUN apt update
RUN apt install -y python
RUN apt install -y python-pip
RUN apt install -y python-virtualenv
RUN apt install -y locales
RUN apt install -y sudo
RUN apt install -y libhdf5-dev
RUN apt install -y libhdf5-serial-dev
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

# ROS関連のPythonパッケージのインストール
RUN apt update
RUN apt install -y python-rosdep
RUN apt install -y python-rosinstall
RUN apt install -y python-rosinstall-generator
RUN apt install -y python-wstool
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

# ロケールの設定
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# get-pip.pyを使用してpipをアップグレード (Python 2.7用)
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
RUN python get-pip.py

# setuptools のインストール
RUN pip install setuptools

# catkin_tools のインストール
RUN pip install catkin_tools

# ROS Kineticのセットアップ
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt update
RUN apt install -y ros-kinetic-desktop-full
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

# ROSの初期設定
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash"

# Gazeboのインストール（Kineticに対応するバージョン）
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt update
RUN apt install -y gazebo7
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

# ROSパッケージの依存関係をインストール
RUN rosdep init
RUN rosdep update

# Pythonの深層学習ライブラリのインストール
RUN pip install numpy
RUN pip install scipy
RUN pip install matplotlib
RUN pip install pandas
RUN pip install scikit-learn
RUN pip install torch
RUN pip install torchvision

# 作業ディレクトリの作成
WORKDIR /root/catkin_ws

# エントリーポイントの設定
CMD ["bash"]
