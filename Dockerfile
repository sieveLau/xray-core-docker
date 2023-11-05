# syntax=docker/dockerfile:1

FROM golang:1.21 as build
WORKDIR /app
COPY Xray-core/go.mod Xray-core/go.sum ./
RUN go mod download
COPY Xray-core .
RUN CGO_ENABLED=0 GOOS=linux go build -o /xray -trimpath -ldflags "-s -w -buildid=" ./main

FROM alpine as main

COPY --from=build /xray /usr/bin/xray
RUN mkdir -p /etc/xray
WORKDIR /etc/xray
ENV XRAY_LOCATION_ASSET=/etc/xray
ENV XRAY_LOCATION_CONFIG=/etc/xray
ENV XRAY_LOCATION_CONFDIR=/etc/xray
CMD ["/usr/bin/xray"]
