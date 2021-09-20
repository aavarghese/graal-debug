FROM ubuntu:18.04
MAINTAINER Ansu Varghese <avarghese@us.ibm.com>

#graavl exec jar in current dir dloaded from https://github.com/graalvm/graalvm-ce-builds/releases
COPY graalvm-ce-java11-linux-amd64-21.2.0.tar.gz /
#quarkus project as jar with Hello.java in current dir 
COPY hello.jar /

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy install \
  openjdk-11-jdk

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy install \
  ant \
  build-essential \
  cpp \
  gdb \
  git \
  gradle \
  jq \
  libcurl3-gnutls \
  libc6-dbg \
  libz-dev \
  make \
  maven \
  mercurial \
  python3-pip \
  python3-requests \
  unzip \
  wget \
  valgrind \
  zlib1g-dev

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN tar -xzf graalvm-ce-java11-linux-amd64-21.2.0.tar.gz
ENV PATH /graalvm-ce-java11-21.2.0/bin:$PATH
ENV JAVA_HOME /graalvm-ce-java11-21.2.0/
ENV GRAALVM_HOME /graalvm-ce-java11-21.2.0/
RUN gu install native-image

RUN git clone https://github.com/graalvm/mx.git
ENV PATH /mx:$PATH

RUN jar xvf hello.jar
RUN cd code-with-quarkus/ \
&& chmod -R a+rwx * \
&& mvn dependency:sources \
&& ./mvnw package -Pnative -Dquarkus.native.debug.enabled=true

ENTRYPOINT ["tail", "-f", "/dev/null"]
