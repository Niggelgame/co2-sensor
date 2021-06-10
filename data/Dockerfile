FROM arm32v7/golang:1.16-alpine3.13 as builder

WORKDIR /app

RUN apk add --no-cache build-base

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=1 GOOS=linux go build cmd/data/main.go

FROM arm32v7/alpine:3.13

RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
CMD ["/root/main"]
