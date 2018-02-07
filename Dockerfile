FROM bitnami/minideb:stretch as build-env

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install python-pip make build-essential curl openssl vim jq gettext git wget \
    && rm -rf /var/lib/apt/lists/*

ENV GO_VERSION 1.8.3

RUN wget -q https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && rm go${GO_VERSION}.linux-amd64.tar.gz

RUN curl -fsSL https://get.docker.com/ | sh

ENV KUBECTL_VERSION 1.7.5
RUN curl "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" > /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

ENV GOPATH /gopath
ENV PATH "${PATH}:${GOPATH}/bin:/usr/local/go/bin"

RUN git clone https://github.com/akesterson/cmdarg.git /tmp/cmdarg \
    && cd /tmp/cmdarg && make install && rm -rf /tmp/cmdarg
RUN git clone https://github.com/akesterson/shunit.git /tmp/shunit \
    && cd /tmp/shunit && make install && rm -rf /tmp/shunit

ENV BRANCH master

ADD https://api.github.com/repos/Azure/acs-engine/git/refs/heads/$BRANCH version.json
RUN git clone -b $BRANCH --single-branch --depth 1 https://github.com/Azure/acs-engine.git /gopath/src/github.com/Azure/acs-engine
WORKDIR /gopath/src/github.com/Azure/acs-engine
RUN make bootstrap && make build

# ---------------------------Minimal Image------------------------------------- #

FROM bitnami/minideb:stretch
COPY --from=build-env ["/gopath/src/github.com/Azure/acs-engine/bin/acs-engine","/bin/acs-engine"]
ENTRYPOINT ["/bin/acs-engine"]

