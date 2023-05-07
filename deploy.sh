#!/bin/bash

# 设置镜像和容器名称
IMAGE_NAME="yidadaa/chatgpt-next-web"
CONTAINER_NAME="chatgpt_next_web_container"

# 检查是否有正在运行的同名镜像的容器
EXISTING_CONTAINER_ID=$(sudo docker ps -a -q -f ancestor="$IMAGE_NAME")

# 如果存在，则停止并删除
if [ ! -z "$EXISTING_CONTAINER_ID" ]; then
    echo "发现同名容器，正在停止并删除..."
    sudo docker stop $EXISTING_CONTAINER_ID
    sudo docker rm $EXISTING_CONTAINER_ID
fi

# 获取用户输入的 OpenAI API Key、密码和映射端口
read -p "请输入您的 OpenAI API Key: " OPENAI_API_KEY
read -p "请输入您想要的密码，以逗号分隔，最多不超过3个: " PASSWORDS
read -p "请输入您希望映射到服务器的端口: " MAPPED_PORT

# 拉取最新的镜像
echo "拉取最新镜像..."
sudo docker pull $IMAGE_NAME

# 运行容器
echo "运行容器..."
sudo docker run -d \
    --name $CONTAINER_NAME \
    --restart always \
    -p $MAPPED_PORT:3000 \
    -e OPENAI_API_KEY="$OPENAI_API_KEY" \
    -e CODE="$PASSWORDS" \
    $IMAGE_NAME

# 检查容器状态
echo "容器状态："
sudo docker ps --filter "name=$CONTAINER_NAME"
