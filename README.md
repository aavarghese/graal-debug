# graal-debug

Clone this repo, and then run the following commands:

First, download graalvm binary for Linux from https://github.com/graalvm/graalvm-ce-builds/releases and place `graalvm-ce-java11-linux-amd64-21.2.0.tar.gz` into the same directory `graal-debug`.

```
brew install vagrant
vagrant autocomplete install --bash --zsh
vagrant up
vagrant docker-exec default -it -- /bin/bash
```

Once you have exec'ed into the docker container, you can do the following:

```
cd code-with-quarkus/target
gdb code-with-quarkus-1.0.0-SNAPSHOT-runner
```

To delete a running vagrant box:

```
vagrant global-status
vagrant destroy #VagrantEnvID
```
