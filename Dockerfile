FROM golang:1.20-buster AS builder

ARG TARGETARCH
ENV GOARCH=$TARGETARCH

WORKDIR /app

RUN git clone https://github.com/coredhcp/coredhcp.git

WORKDIR /app/coredhcp/cmds/coredhcp

RUN GOARCH=$GOARCH go build -o /coredhcp .

FROM gcr.io/distroless/base-debian12

COPY --from=builder /coredhcp /usr/local/bin/coredhcp

ENTRYPOINT ["/usr/local/bin/coredhcp"]

CMD ["-h"]

EXPOSE 67/udp
