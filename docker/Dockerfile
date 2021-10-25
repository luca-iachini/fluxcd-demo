ARG GOLANG_IMAGE=golang:1.17-alpine

FROM ${GOLANG_IMAGE} AS build

ARG package

RUN mkdir -p /app
WORKDIR /app

COPY go/${package}/go.mod .
COPY go/${package}/go.sum .
RUN go mod download

COPY go/${package}/ .
RUN go build -o ./server ./main.go

FROM ${GOLANG_IMAGE} AS serve


RUN mkdir -p /app

WORKDIR /app
COPY --from=build /app/server .

EXPOSE 8080

ENTRYPOINT ["./server"]
