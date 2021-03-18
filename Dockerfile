FROM alpine:3.13@sha256:a75afd8b57e7f34e4dad8d65e2c7ba2e1975c795ce1ee22fa34f8cf46f96a3be

ENV FPC_VERSION="3.2.0" \
    FPC_ARCH="x86_64-linux"

RUN apk add --no-cache --virtual .build-deps binutils curl && \
    mkdir /tmp/fpc-$FPC_VERSION-$FPC_ARCH && \
    curl -L https://downloads.sourceforge.net/project/freepascal/Linux/$FPC_VERSION/fpc-$FPC_VERSION-$FPC_ARCH.tar | tar -x -C /tmp/fpc-$FPC_VERSION-$FPC_ARCH --strip-components=1 && \
    rm /tmp/fpc-$FPC_VERSION-$FPC_ARCH/demo* /tmp/fpc-$FPC_VERSION-$FPC_ARCH/doc* && \
    ln -s /lib /lib64 && ln -s /lib/ld-musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2 && \
    cd /tmp/fpc-$FPC_VERSION-$FPC_ARCH && \
    echo -e '/usr\nN\nN\nN\n' | sh /tmp/fpc-$FPC_VERSION-$FPC_ARCH/install.sh && \
    find /usr/lib/fpc/$FPC_VERSION/units/$FPC_ARCH/ -type d -mindepth 1 -maxdepth 1 \
        -not -name 'fcl-base' \
        -not -name 'rtl' \
        -not -name 'rtl-console' \
        -not -name 'rtl-objpas' \
        -exec rm -r {} \; && \
    rm -r /lib64 /tmp/* && \
    rm -fr /tmp/fpc-$FPC_VERSION-$FPC_ARCH && \
    apk del .build-deps && \
    mkdir /fpc

WORKDIR /fpc