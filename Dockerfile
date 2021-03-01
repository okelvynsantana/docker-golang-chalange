FROM golang:1.15.6-alpine AS builder

RUN apk update && apk add --no-cache

WORKDIR /src

ENV PATH="/go/bin:${PATH}"

COPY main.go .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -a -installsuffix cgo -o main main.go

FROM scratch AS prod

WORKDIR /app

COPY --from=builder /src/main .

ENTRYPOINT [ "./main" ]