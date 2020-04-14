FROM golang:1.13-buster as build
WORKDIR /go/src/app
ADD . /go/src/app
RUN CGO_ENABLED=0 GOOS=linux go build -mod=vendor -o /go/bin/app ./main.go

FROM gcr.io/distroless/base-debian10
COPY --from=build /go/bin/app /
CMD ["./app"]
