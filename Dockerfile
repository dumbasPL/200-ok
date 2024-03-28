FROM --platform=$BUILDPLATFORM golang:alpine AS builder

WORKDIR /app

COPY go.mod main.go ./

ARG TARGETOS TARGETARCH TARGETVARIANT

RUN export GOOS="$TARGETOS"; \
    export GOARCH="$TARGETARCH"; \
    if [ -n TARGETVARIANT ] && [ "$TARGETARCH" = "arm" ]; then \
      export GOARM="${TARGETVARIANT//v}"; \
    fi; \
    go build -ldflags="-w -s" -o /app/200-ok

FROM scratch

COPY --from=builder /app/200-ok /200-ok

EXPOSE 8080

ENTRYPOINT ["/200-ok"]