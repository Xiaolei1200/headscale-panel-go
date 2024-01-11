FROM docker.io/golang:1.20-bullseye AS build
LABEL authors="QianheYu"

WORKDIR /src
COPY . .
#ENV GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
ENV GOPROXY=https://goproxy.cn,direct

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apt-get update && apt-get install -y git
# 设置 Go 模块代理
RUN make build

FROM docker.io/debian:bullseye-slim
LABEL authors="QianheYu"
LABEL all-in-one=true

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apt-get update && apt-get install -y ca-certificates

RUN mkdir -p /etc/headscale-panel && mkdir -p /etc/headscale && mkdir -p /var/lib/headscale && mkdir -p /var/run/headscale

COPY --from=build /src/bin/headscale-panel /bin/headscale-panel
ENV TZ UTC

CMD ["headscale-panel"]
