FROM golang:1.11beta2 

WORKDIR /home/jenkins

ENV GH_RELEASE_VERSION 2.2.1
RUN wget https://github.com/progrium/gh-release/releases/download/v$GH_RELEASE_VERSION/gh-release_${GH_RELEASE_VERSION}_linux_x86_64.tgz && \
  tar -xzf gh-release_${GH_RELEASE_VERSION}_linux_x86_64.tgz && \
  mv gh-release /usr/local/gh-release && \
  rm gh-release_${GH_RELEASE_VERSION}_linux_x86_64.tgz

ENV JQ_RELEASE_VERSION 1.5
RUN wget https://github.com/stedolan/jq/releases/download/jq-${JQ_RELEASE_VERSION}/jq-linux64 && mv jq-linux64 jq && chmod +x jq && cp jq /usr/bin/jq

RUN apt-get -y update && apt-get -y install unzip
ENV PROTOBUF 3.5.1
RUN wget https://github.com/google/protobuf/releases/download/v${PROTOBUF}/protoc-${PROTOBUF}-linux-x86_64.zip && \
  unzip protoc-${PROTOBUF}-linux-x86_64.zip -d protoc && \
  chmod +x protoc && cp protoc/bin/protoc /usr/bin/protoc && rm -rf protoc

# helm
ENV HELM_VERSION 2.10.0-rc.1
RUN curl https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz  | tar xzv && \
  mv linux-amd64/helm /usr/bin/ && \
  rm -rf linux-amd64

RUN curl -L https://github.com/jstrachan/helm/releases/download/untagged-93375777c6644a452a64/helm-linux-amd64.tar.gz -o helm3.tgz && \
  tar xf helm3.tgz && \
  mv helm /usr/bin/helm3

# skaffold
ENV SKAFFOLD_VERSION 0.9.0
RUN curl -Lo skaffold https://github.com/GoogleCloudPlatform/skaffold/releases/download/v${SKAFFOLD_VERSION}/skaffold-linux-amd64 && \
  chmod +x skaffold && \
  mv skaffold /usr/bin

# jx-release-version
ENV JX_RELEASE_VERSION 1.0.10
RUN curl -o ./jx-release-version -L https://github.com/jenkins-x/jx-release-version/releases/download/v${JX_RELEASE_VERSION}/jx-release-version-linux && \
  mv jx-release-version /usr/bin/ && \
  chmod +x /usr/bin/jx-release-version

CMD ["go","version"]
