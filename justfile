#!/usr/bin/env just --justfile

APP := "jxmlval"
DOCKER_IMAGE := "andreburgaud" / APP
VERSION := "0.2.0"
NATIVE_DIR := "native"

alias d := docker
alias db := docker-build
alias dp := docker-push
alias ds := docker-scout
alias ghp := github-push
alias gj := gradle-jar
alias c := clean
alias nl := native-linux

# Default recipe (this list)
default:
    @just --list

# Execute all tasks leading to release
all: test docker-build docker-scout native-linux

# Complete docker image build and security validation
docker: docker-build docker-scout

# Build a docker image
docker-build: clean
    docker build -t andreburgaud/{{APP}}:latest .
    docker tag andreburgaud/{{APP}}:latest andreburgaud/{{APP}}:{{VERSION}}

# Docker scout (container image security scan)
docker-scout:
    docker scout cves andreburgaud/{{APP}}:{{VERSION}}

# Push showcert docker image to docker hub
docker-push: docker
    docker push docker.io/{{DOCKER_IMAGE}}:{{VERSION}}
    docker tag {{DOCKER_IMAGE}}:{{VERSION}} docker.io/{{DOCKER_IMAGE}}:latest
    docker push docker.io/{{DOCKER_IMAGE}}:latest

# Run from an install distribution
run *ARGS:
    ./gradlew installDist
    ./build/install/jxmlval/bin/jxmlval {{ARGS}}

# Generate the jar file
gradle-jar:
    ./gradlew jar

# Generate native image
gradle-native:
    ./gradlew nativeCompile

# Clean build and release artifacts
clean:
    ./gradlew clean
    -rm -rf {{NATIVE_DIR}}
    -rm -rf ./bin

# Execute unit tests
test:
    ./gradlew test

# Native compile via container (Linux only)
native-linux: docker-build
    mkdir ./bin
    docker create --name {{APP}}-build andreburgaud/{{APP}}:{{VERSION}}
    docker cp {{APP}}-build:/{{APP}} ./bin
    docker rm -f {{APP}}-build
    zip -j bin/{{APP}}-{{VERSION}}_linux_{{arch()}}.zip bin/{{APP}}

# Direct native compile
native-image: clean
    ./gradlew installDist
    mkdir -p {{NATIVE_DIR}}/bin
    native-image -march=native --initialize-at-build-time={{APP}} -cp ./build/install/{{APP}}/lib/picocli-4.7.5.jar --no-fallback -jar ./build/install/{{APP}}/lib/{{APP}}.jar -o {{NATIVE_DIR}}/bin/{{APP}}
    zip -j {{NATIVE_DIR}}/{{APP}}-{{VERSION}}_{{os()}}_{{arch()}}.zip {{NATIVE_DIR}}/bin/{{APP}}

# Push and tag changes to github
github-push:
    git push
    git tag -a {{VERSION}} -m 'Version {{VERSION}}'
    git push origin --tags
