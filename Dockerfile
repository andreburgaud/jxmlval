# syntax=docker/dockerfile:1

FROM container-registry.oracle.com/graalvm/native-image:21.0.1-muslib-ol9-20240103 as build

ENV LANG=C.UTF-8

WORKDIR /jxmlval

RUN useradd -u 10001 jxmlvaluser

RUN microdnf -y install findutils xz

RUN curl --location --output upx-4.2.2-amd64_linux.tar.xz "https://github.com/upx/upx/releases/download/v4.2.2/upx-4.2.2-amd64_linux.tar.xz" && \
    tar -xJf "upx-4.2.2-amd64_linux.tar.xz" && \
    cp upx-4.2.2-amd64_linux/upx /bin/

RUN mkdir -p ./native/bin && \
    mkdir /files

ADD . .

RUN ./gradlew installDist --no-daemon

RUN native-image -march=compatibility -cp /jxmlval/build/install/jxmlval/lib/picocli-4.7.5.jar --static --no-fallback --libc=musl -jar /jxmlval/build/install/jxmlval/lib/jxmlval.jar -o /jxmlval/native/bin/jxmlval && \
    strip /jxmlval/native/bin/jxmlval && \
    upx --best /jxmlval/native/bin/jxmlval

FROM scratch
COPY --from=build /jxmlval/native/bin/jxmlval /jxmlval
COPY --from=build /files /files
COPY --from=build /etc/passwd /etc/passwd

ENV LANG=C.UTF-8

USER jxmlvaluser

ENTRYPOINT [ "/jxmlval" ]
