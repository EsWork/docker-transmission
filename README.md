[![Build Status](https://travis-ci.org/EsWork/docker-transmission.svg?branch=master)](https://travis-ci.org/EsWork/docker-transmission) 
[![](https://images.microbadger.com/badges/image/eswork/transmission.svg)](https://microbadger.com/images/eswork/transmission "Get your own image badge on microbadger.com")

## Supported tags and respective `Dockerfile` links

- [`latest` (Dockerfile)](https://github.com/eswork/docker-transmission/blob/master/Dockerfile)

Introduction
---

基于`Alpine linux`镜像构建`transmission`

Getting started

Installation
---

自动化构建镜像的可用[Dockerhub](https://hub.docker.com/r/eswork/transmission)和推荐的安装方法

```bash
docker pull eswork/transmission:latest
```

或者你可以自己构建镜像

```bash
docker build -t eswork/transmission github.com/eswork/docker-transmission
```

Quickstart
---

运行transmission：

```bash
docker run --name transmission -d \
  -p 9091:9091 \
  -v /data/transmission/downloads:/transmission/download \
  -v /data/transmission/incomplete:/transmission/incomplete \
  -v /data/transmission/info:/transmission/info \
  -v /etc/localtime:/etc/localtime:ro \
  --restart=unless-stopped -d \
  eswork/transmission
```

或者您可以使用示例[docker-compose.yml](docker-compose.yml)文件启动容器

