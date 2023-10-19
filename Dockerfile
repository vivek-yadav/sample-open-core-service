# First stage: build the executable.
FROM golang:1.21.1-alpine AS builder
# It is important that these ARG's are defined after the FROM statement
ARG ACCESS_TOKEN_USR="nothing"
ARG ACCESS_TOKEN_PWD="nothing"
ARG BUILD_ARGS=""
# git is required to fetch go dependencies
RUN apk add --no-cache ca-certificates git
# Create the user and group files that will be used in the running 
# container to run the process as an unprivileged user.
RUN mkdir /user && \
    echo 'nobody:x:65534:65534:nobody:/:' > /user/passwd && \
    echo 'nobody:x:65534:' > /user/group
# Create a netrc file using the credentials specified using --build-arg
RUN printf "machine github.com\n\
    login ${ACCESS_TOKEN_USR}\n\
    password ${ACCESS_TOKEN_PWD}\n\
    \n\
    machine api.github.com\n\
    login ${ACCESS_TOKEN_USR}\n\
    password ${ACCESS_TOKEN_PWD}\n"\
    >> /root/.netrc
RUN chmod 600 /root/.netrc
# Set the working directory outside $GOPATH to enable the support for modules.
WORKDIR /src

# Import the code from the context.
COPY . .
# Fetch dependencies first; they are less susceptible to change on every build
# and will therefore be cached for speeding up the next build
# COPY ./go.mod ./go.sum ./
RUN go mod init github.com/vivek-yadav/sample-open-core-service
RUN GOPRIVATE="github.com/vivek-yadav/*" go mod tidy
RUN cat go.mod

# Build the executable to `/app`. Mark the build as statically linked.
RUN  CGO_ENABLED=0 go build ${BUILD_ARGS} \
    -installsuffix 'static' \
    -o /app ./
# Final stage: the running container.
# FROM ubuntu AS final
# Import the user and group files from the first stage.
#COPY --from=builder /user/group /user/passwd /etc/
# Import the Certificate-Authority certificates for enabling HTTPS.
#COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# Import the compiled executable from the first stage.
#COPY --from=builder /app /app
# Perform any further action as an unprivileged user.
#USER nobody:nobody
# Run the compiled binary.
ENTRYPOINT ["/app","server","run","-c","config/config.yaml"]