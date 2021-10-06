FROM ubuntu:18.04
LABEL maintainer="Ansu Varghese <avarghese@us.ibm.com>"

#Dockerfile input is the address to start the JDWP server on
ARG ADDRESS_ARG="localhost:8000"

EXPOSE 8000
HEALTHCHECK CMD wget -q -O /dev/null http://localhost:8000/healthy || exit 1

WORKDIR /jdwp

COPY JDB-1.0-SNAPSHOT.jar /jdwp

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy install \
  openjdk-11-jdk

ENV SOCKET_ADDRESS=$ADDRESS_ARG
#ENV JAVA_TOOL_OPTIONS -agentlib:jdwp=transport=dt_socket,address=*:8000,server=y,suspend=y

#Java wrapper starting JDWP server listening for JDWP request packets
ENTRYPOINT java -cp JDB-1.0-SNAPSHOT.jar JDWPServer $SOCKET_ADDRESS
