FROM ubuntu:18.04
LABEL maintainer="Ansu Varghese <avarghese@us.ibm.com>"

#Dockerfile input is a maven project directory that has a pom with native profile
ARG INPUT_DIR
COPY $INPUT_DIR /$INPUT_DIR

#Dockerfile input is an already built native-image exec
ARG INPUT_NATIVE_EXEC

EXPOSE 8000
HEALTHCHECK CMD wget -q -O /dev/null http://localhost:8000/healthy || exit 1

#graavl exec jar in current dir downloaded from https://github.com/graalvm/graalvm-ce-builds/releases
COPY graalvm-ce-java11-linux-amd64-21.2.0.tar.gz /
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
  vim \
  zlib1g-dev

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

#Install graal VM and native image exec
RUN tar -xzf /graalvm-ce-java11-linux-amd64-21.2.0.tar.gz
ENV PATH /graalvm-ce-java11-21.2.0/bin:$PATH
ENV JAVA_HOME /graalvm-ce-java11-21.2.0/
ENV GRAALVM_HOME /graalvm-ce-java11-21.2.0/
RUN gu install native-image

# (Optional) install mx
RUN git clone https://github.com/graalvm/mx.git
ENV PATH /mx:$PATH

#If an application jar or class file is inputted, build native image executable
#TODO: Use input args
RUN cd hello \
&& chmod -R a+rwx * \
&& mvn dependency:sources \
&& ./mvnw package -Pnative -Dquarkus.native.debug.enabled=true

#TODO: Use input args
ENV NATIVE_EXEC target/hello

#Java wrapper running gdb on native image executable
#At least two arguments required! First argument must be the native executable path. Second argument is the file with input GDB commands. Third optional argument is the output file.
ENTRYPOINT ["java", "-cp", "/JDB-1.0-SNAPSHOT.jar", "jdb.JDB", "$NATIVE_EXEC", "/code/input.txt", "/code/output.txt"]
