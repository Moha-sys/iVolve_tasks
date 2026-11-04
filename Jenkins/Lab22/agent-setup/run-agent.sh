#!/usr/bin/env bash
export JAVA_HOME="/home/moha/.tools/jdk-21"
export PATH="/home/moha/.tools/jdk-21/bin:/home/moha/.tools/apache-maven-3.9.9/bin:/home/moha/.local/bin:/usr/local/bin:/usr/bin:$PATH"

exec java -jar /home/moha/jenkins-agent/agent.jar \
  -url http://localhost:8080/ \
  -secret 8ccb9eff45912c5ec9c1dcf3226572152f8f376591e0dd6b01981c61784abaa7 \
  -name slave-node \
  -workDir "/home/moha/jenkins-agent" \
  -webSocket
