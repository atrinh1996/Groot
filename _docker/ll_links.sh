#!/bin/bash

#
# Author  : Zachary Goldstein
# Created : 15 March 2022
# Purpose : for the sake of convenience and backwards-compatibility,
#           this script symlinks all llvm scripts of the form
#           "SCRIPT_NAME-13" with targets of the form "SCRIPT_NAME".
#           

TARGET_DIR="/usr/bin"
LINK_DIR="/usr/links"

mkdir $LINK_DIR

for TARGET in $( ls $TARGET_DIR | grep -e "-13\b" )
do
	LINK_NAME=$(echo $TARGET | sed 's/...$//' )
	echo $LINK_NAME
	ln -s $TARGET_DIR/$TARGET $LINK_DIR/$LINK_NAME
done