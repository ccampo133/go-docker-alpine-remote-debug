FROM golang:alpine3.17 AS build

WORKDIR /app

# Turning off Cgo is required to install Delve on Alpine.
ENV CGO_ENABLED=0

# Download and install the Delve debugger.
RUN go install github.com/go-delve/delve/cmd/dlv@latest

COPY go.mod .
COPY go.sum .

RUN go mod download

# You'll want to copy all your .go files here in a bigger project.
COPY main.go .

# Disable inlining and optimizations that can interfere with debugging.
RUN go build -gcflags "all=-N -l" -o /main main.go

FROM alpine:3.17

WORKDIR /

COPY --from=build /go/bin/dlv /bin/dlv
COPY --from=build /main /bin/app
COPY run.sh /bin/run.sh

EXPOSE 8080

ENTRYPOINT ["/bin/run.sh"]
