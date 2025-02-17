FROM docker.io/golang:alpine AS build
LABEL authors="QianheYu"

WORKDIR /src
COPY . .
ENV GOPROXY=https://goproxy.cn,direct
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update && apk add --no-cache make git

RUN make build

FROM docker.io/alpine:latest
LABEL authors="QianheYu"
LABEL all-in-one=true
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update && apk add --no-cache ca-certificates && update-ca-certificates

RUN mkdir -p /etc/headscale-panel && mkdir -p /etc/headscale && mkdir -p /var/lib/headscale && mkdir -p /var/run/headscale

COPY --from=build /src/bin/headscale-panel /bin/headscale-panel
ENV TZ UTC

CMD ["headscale-panel"]
