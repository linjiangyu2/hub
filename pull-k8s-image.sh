#!/bin/sh

# 项目地址 https://github.com/linjiangyu/gcr.io_mirror
k8s_img=$1
mirror_img=$(echo ${k8s_img}|
        sed 's/quay\.io/linjiangyu\/quay/g;s/ghcr\.io/linjiangyu\/ghcr/g;s/registry\.k8s\.io/linjiangyu\/google-containers/g;s/k8s\.gcr\.io/linjiangyu\/google-containers/g;s/gcr\.io/linjiangyu/g;s/\//\./g;s/ /\n/g;s/linjiangyu\./linjiangyu\//g' |
        uniq)

if [ -x "$(command -v docker)" ]; then
  sudo docker pull ${mirror_img}
  sudo docker tag ${mirror_img} ${k8s_img}
  exit 0
fi

if [ -x "$(command -v ctr)" ]; then
  sudo ctr -n k8s.io image pull docker.io/${mirror_img}
  sudo ctr -n k8s.io image tag docker.io/${mirror_img} ${k8s_img}
  exit 0
fi

echo "command not found:docker or ctr"
