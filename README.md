このリポジトリは未完成です。！！noeticwsの方は動きます。

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

（注１）
永続的にdockerにxサーバの権限を与えたいときは/etc/profile.d/がログインシェルの起動時に自動的に実行されるスクリプトが格納されるファイルにいかにコマンドを実行し追加  
＄sudo vim /etc/profile.d/xhost_local_docker.sh  
内容が下  
----------------  
#!/bin/bash  
xhost +local:docker  
----------------  
$sudo chmod +x /etc/profile.d/xhost_local_docker.sh  
$sudo reboot  
その後下のコマンドで確認。  
$xhost  


