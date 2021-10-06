FROM ubuntu:18.04
LABEL maintainer="Ansu Varghese <avarghese@us.ibm.com>"

#Dockerfile input is a maven project directory that has a pom with native profile
ARG INPUT_DIR

#Dockerfile input is an already built native-image exec
ARG INPUT_NATIVE_EXEC

EXPOSE 8000
HEALTHCHECK CMD wget -q -O /dev/null http://localhost:8000/healthy || exit 1

WORKDIR /gdb

#graavl exec jar in current dir downloaded from https://github.com/graalvm/graalvm-ce-builds/releases
COPY graalvm-ce-java11-21.2.0 /gdb/graalvm-ce-java11-21.2.0
COPY JDB-1.0-SNAPSHOT.jar /gdb
COPY getting-started /gdb/getting-started
COPY Hello /gdb/Hello

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy install \
  openjdk-11-jdk

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy install \
  emacs \
  git \
  gradle \
  jq \
  make \
  maven \
  python3-pip \
  python3-requests \
  unzip \
  wget \
  valgrind \
  vim \
  zlib1g-dev

#Install graal VM and native image exec
#RUN tar -xzf graalvm-ce-java11-linux-amd64-21.2.0.tar.gz
ENV PATH /gdb/graalvm-ce-java11-21.2.0/bin:$PATH
ENV JAVA_HOME /gdb/graalvm-ce-java11-21.2.0
ENV GRAALVM_HOME /gdb/graalvm-ce-java11-21.2.0
RUN $GRAALVM_HOME/bin/gu install native-image

# (Optional) install mx
# RUN git clone https://github.com/graalvm/mx.git
# ENV PATH /gdb/mx:$PATH

#Build native image executables
#TODO: Use input args
#WORKDIR /gdb/getting-started
#RUN ./mvnw package -Pnative -Dquarkus.native.debug.enabled=true

WORKDIR /gdb/Hello
RUN native-image -g Hello

#TODO: Use input args
#ENV NATIVE_EXEC /gdb/getting-started/target/getting-started-1.0.0-SNAPSHOT-runner
ENV NATIVE_EXEC /gdb/Hello/hello

WORKDIR /gdb

#Java wrapper running gdb on native image executable
#At least two arguments required! First argument must be the native executable path. Second argument is the file with input GDB commands. Third optional argument is the output file.
ENTRYPOINT java -cp JDB-1.0-SNAPSHOT.jar GDB $NATIVE_EXEC /code/input.txt /code/output.txt
