FROM jenkinsxio/builder-base:0.1.77

RUN yum -y groupinstall 'Development Tools'
RUN curl -f -o /etc/yum.repos.d/vbatts-bazel-epel-7.repo  https://copr.fedorainfracloud.org/coprs/vbatts/bazel/repo/epel-7/vbatts-bazel-epel-7.repo && \
  yum install -y bazel

ENV GOLANG_VERSION 1.11.2
RUN wget https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go$GOLANG_VERSION.linux-amd64.tar.gz && \
  rm go${GOLANG_VERSION}.linux-amd64.tar.gz

ENV GLIDE_VERSION v0.13.1
ENV GO15VENDOREXPERIMENT 1
RUN wget https://github.com/Masterminds/glide/releases/download/$GLIDE_VERSION/glide-$GLIDE_VERSION-linux-amd64.tar.gz && \
  tar -xzf glide-$GLIDE_VERSION-linux-amd64.tar.gz && \
  mv linux-amd64 /usr/local/glide && \
  rm glide-$GLIDE_VERSION-linux-amd64.tar.gz

ENV GH_RELEASE_VERSION 2.2.1
RUN wget https://github.com/progrium/gh-release/releases/download/v$GH_RELEASE_VERSION/gh-release_${GH_RELEASE_VERSION}_linux_x86_64.tgz && \
  tar -xzf gh-release_${GH_RELEASE_VERSION}_linux_x86_64.tgz && \
  mv gh-release /usr/local/gh-release && \
  rm gh-release_${GH_RELEASE_VERSION}_linux_x86_64.tgz

ENV JQ_RELEASE_VERSION 1.5
RUN wget https://github.com/stedolan/jq/releases/download/jq-${JQ_RELEASE_VERSION}/jq-linux64 && mv jq-linux64 jq && chmod +x jq && cp jq /usr/bin/jq

ENV PROTOBUF 3.5.1
RUN wget https://github.com/google/protobuf/releases/download/v${PROTOBUF}/protoc-${PROTOBUF}-linux-x86_64.zip && \
  unzip protoc-${PROTOBUF}-linux-x86_64.zip -d protoc && \
  chmod +x protoc && cp protoc/bin/protoc /usr/bin/protoc && rm -rf protoc


ENV PATH $PATH:/usr/local/go/bin
ENV PATH $PATH:/usr/local/glide
ENV PATH $PATH:/usr/local/
ENV GOROOT /usr/local/go
ENV GOPATH=/home/jenkins/go
ENV PATH $PATH:$GOPATH/bin

RUN go get github.com/DATA-DOG/godog/cmd/godog && \
  mv $GOPATH/bin/godog /usr/local/ && \
  rm -rf $GOPATH/src/github.com/DATA-DOG

RUN go get github.com/gohugoio/hugo && \
  mv $GOPATH/bin/hugo /usr/local/ && \
  rm -rf $GOPATH/src/github.com/gohugoio
  
RUN go get github.com/derekparker/delve/cmd/dlv && \
  mv $GOPATH/bin/* /usr/local/ && \
  rm -rf $GOPATH/src/github.com/derekparker

RUN go get github.com/golang/protobuf/proto && \
  go get github.com/micro/protoc-gen-micro && \
  go get github.com/golang/protobuf/protoc-gen-go && \ 
  go get -u github.com/micro/micro && \
  mv $GOPATH/bin/* /usr/local/ && \ 
  cp -r $GOPATH/src/* /usr/local/go/src    

CMD ["go","version"]
