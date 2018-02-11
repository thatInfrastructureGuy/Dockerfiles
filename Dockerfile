FROM bitnami/minideb:stretch as build-env
MAINTAINER ashish52.kulkarni@gmail.com

RUN groupadd --gid 1000 scratchuser \
  && useradd --uid 1000 --gid scratchuser --shell /usr/sbin/nologin --create-home scratchuser -p scratchuser

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install python-pip make build-essential curl openssl vim jq gettext git wget \
    && rm -rf /var/lib/apt/lists/*

ENV GO_VERSION 1.9.4
ENV SHASUM 15b0937615809f87321a457bb1265f946f9f6e736c563d6c5e0bd2c22e44f779

RUN wget -q https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz -O go.tar.gz \
&&  if [ "$SHASUM  go.tar.gz" != "$(sha256sum go.tar.gz)" ]; then echo "SHASUM check error" && exit 1; else echo "SHASUM OK"; fi \
&& tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz

ENV GOPATH /gopath
ENV PATH "${PATH}:${GOPATH}/bin:/usr/local/go/bin"

ENV BRANCH master

# Add command discards docker cache build if new commits are added
ADD https://api.github.com/repos/Azure/acs-engine/git/refs/heads/$BRANCH version.json

# Do a shallow clone. save bandwidth
RUN git clone -b $BRANCH --single-branch --depth 1 https://github.com/Azure/acs-engine.git /gopath/src/github.com/Azure/acs-engine
WORKDIR /gopath/src/github.com/Azure/acs-engine
RUN make bootstrap && make build-cross
RUN cd ./_dist/ &&  for i in acs-engine-*; do if [ $i = *"-linux-amd64" ]; then cd $i; mv ./acs-engine /bin/acs-engine; chmod 500 /bin/acs-engine; fi; done

# ---------------------------Minimal Image------------------------------------- #

FROM scratch
COPY --from=build-env ["/etc/passwd", "/etc/passwd"]
COPY --from=build-env ["/etc/group","/etc/group"]
COPY --from=build-env --chown=scratchuser:scratchuser ["/bin/acs-engine","/bin/acs-engine"]
USER scratchuser
ENTRYPOINT ["/bin/acs-engine"]
CMD ["version"]
