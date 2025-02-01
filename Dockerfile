FROM alpine:3.14 as build

WORKDIR /tmp/src/
RUN apk update && \
    apk add gcc g++ make python3 git && \
    git clone https://github.com/skeeto/bf-x86.git . && \
    make 

COPY . . 

FROM alpine:3.14 as compiler

WORKDIR /tmp/
COPY --from=build /tmp/src/bf-x86 /usr/local/bin/bf-x86
COPY --from=build /tmp/src/source.bf .
RUN bf-x86 source.bf

FROM scratch

COPY --from=compiler /tmp/source /awesomebinary
ENTRYPOINT [ "/awesomebinary" ]