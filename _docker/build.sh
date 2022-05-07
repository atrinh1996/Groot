#!/bin/bash

# this file will build an updated docker image
# Zachary Goldstein

echo $( dirname $( realpath $0 ) )/Dockerfile
DIR=$(dirname $(realpath $0))

docker build $DIR -f $DIR/Dockerfile -t "zegger/llvm-opam:latest"