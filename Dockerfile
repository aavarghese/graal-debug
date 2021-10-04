FROM ubuntu:18.04
LABEL maintainer="Ansu Varghese <avarghese@us.ibm.com>"

#Dockerfile input is the address to start the JDWP server on
ARG ADDRESS localhost:8000

EXPOSE 8000
HEALTHCHECK CMD wget -q -O /dev/null http://localhost:8000/healthy || exit 1

COPY JDB-1.0-SNAPSHOT.jar /

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
  emacs \
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
  vim \
  zlib1g-dev

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

#Java wrapper starting JDWP server listening for JDWP request packets
ENTRYPOINT ["java", "-cp", "/JDB-1.0-SNAPSHOT.jar", "jdb.JDWPServer", "$ADDRESS"]
