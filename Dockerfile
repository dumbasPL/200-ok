FROM --platform=$BUILDPLATFORM golang:alpine AS builder

WORKDIR /app

COPY go.mod main.go ./

ARG TARGETOS TARGETARCH

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -ldflags="-w -s" -o /app/200-ok

FROM scratch

COPY --from=builder /app/200-ok /200-ok

EXPOSE 8080

ENTRYPOINT ["/200-ok"]