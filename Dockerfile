FROM golang:1.20-buster AS builder

WORKDIR /app

RUN git clone https://github.com/coredhcp/coredhcp.git

WORKDIR /app/coredhcp/cmds/coredhcp

RUN go build -o /coredhcp .

FROM gcr.io/distroless/static-debian12

COPY --from=builder /coredhcp /usr/local/bin/coredhcp

ENTRYPOINT ["/usr/local/bin/coredhcp"]

CMD ["-h"]

EXPOSE 67/udp
