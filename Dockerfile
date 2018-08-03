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

# jx
ENV JX_VERSION 1.3.44
RUN curl -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

####################### DEPS FOR POTENTIAL REMOVAL IN NORMAL PIPELINE BUILDS ##########################

RUN apt-get update && apt-get install -y \
  bzip2 \
  python-pip

RUN pip install --upgrade pip anchorecli

# java required for updatebot
RUN apt-get update && apt-get install -y openjdk-8-jre

# chrome
RUN apt-get install -y libappindicator1 fonts-liberation libasound2 libnspr4 libnss3 libxss1 lsb-release xdg-utils libappindicator3-1 && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome*.deb && \
    rm google-chrome*.deb

# Docker
ENV DOCKER_VERSION 17.12.0
RUN curl https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION-ce.tgz | tar xvz && \
  mv docker/docker /usr/bin/ && \
  rm -rf docker

# gcloud
ENV GCLOUD_VERSION 187.0.0
RUN curl -L https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz | tar xzv && \
  mv google-cloud-sdk /usr/bin/
ENV PATH=$PATH:/usr/bin/google-cloud-sdk/bin

# install the docker credential plugin
RUN gcloud components install docker-credential-gcr

# exposecontroller
ENV EXPOSECONTROLLER_VERSION 2.3.34
RUN curl -L https://github.com/fabric8io/exposecontroller/releases/download/v$EXPOSECONTROLLER_VERSION/exposecontroller-linux-amd64 > exposecontroller && \
  chmod +x exposecontroller && \
  mv exposecontroller /usr/bin/

# updatebot
ENV UPDATEBOT_VERSION 1.1.13
RUN curl -o ./updatebot -L https://oss.sonatype.org/content/groups/public/io/jenkins/updatebot/updatebot/${UPDATEBOT_VERSION}/updatebot-${UPDATEBOT_VERSION}.jar && \
  chmod +x updatebot && \
  cp updatebot /usr/bin/ && \
  rm -rf updatebot

# draft
RUN curl https://azuredraft.blob.core.windows.net/draft/draft-canary-linux-amd64.tar.gz  | tar xzv && \
  mv linux-amd64/draft /usr/bin/ && \
  rm -rf linux-amd64

# kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
  chmod +x kubectl && \
  mv kubectl /usr/bin/

# aws ecr docker credential helper.
# Currently using https://github.com/estahn/amazon-ecr-credential-helper as there are no releases yet in the main repo
# Main repo issues tracking at https://github.com/awslabs/amazon-ecr-credential-helper/issues/80
RUN mkdir ecr && \
    curl -L https://github.com/estahn/amazon-ecr-credential-helper/releases/download/v0.1.1/amazon-ecr-credential-helper_0.1.1_linux_amd64.tar.gz | tar -xzv -C ./ecr/ && \
    mv ecr/docker-credential-ecr-login /usr/bin/ && \
    rm -rf ecr

CMD ["go","version"]
