FROM golang:1.21.5-alpine3.18 as builder

RUN apk add --no-cache git gmp-dev build-base g++ openssl-dev
ADD . /pactus

# Building pactus-daemon
RUN cd /pactus && \
    go build -ldflags "-s -w" -o ./build/pactus-daemon ./cmd/daemon


## Copy binary files from builder into second container
FROM golang:1.21.5-alpine3.18

COPY --from=builder /pactus/build/pactus-daemon /usr/bin

ENV WORKING_DIR "/pactus"

VOLUME $WORKING_DIR
WORKDIR $WORKING_DIR

ENTRYPOINT ["pactus-daemon"]
