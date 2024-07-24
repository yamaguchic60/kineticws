kinetic,gazebo,c++,python,pytorch関連を触る人用のdockerfileです。
＃まず、Dockerがxサーバに接続するために権限を与える。(注１)
$ xhost +local:docker

#Dockerfileからイメージを作る。最後のピリオドのとおりカレントディレクトリのどっかーファイルを参照しているので、どっかーファイルがあるディレクトリに移動してからビルドしてください。
$ docker build -t kineticimg .
＃イメージからコンテナを作る
$ docker run --name kineticcon -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -it kineticimg
＃動作中のコンテナに入る
$ docker exec -it kineticcon /bin/bash
#docker psで出てこない（コンテナが停止中）のとき
$ docker start kineticcon
