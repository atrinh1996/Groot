#!/bin/bash

# Regression testing script for Groot
# Step through a list of files
#  Run, and check the output of each expected-to-work test
#  Run and check the error of each expected-to-fail test

# Path to the groot compiler.  Usually "./toplevel.native"
#   Try "_build/toplevel.native" if ocamlbuild was unable to create a symbolic
#   link.
#
#  Adopted from MicroC testing script
#   Edited by Nick Gravel - to support testing groot language
#
if [ "$SHELL" != "/bin/bash" ]; then
    echo "Error: run with /bin/bash"
    exit
fi

# make clean
# make toplevel.native

shopt -s extglob

GROOT="./toplevel.native"
#GROOT="_build/toplevel.native"

# Set time limit for all operations
ulimit -t 30

globallog=testall.log
rm -f $globallog
error=0
globalerror=0

keep=0

Usage() {
    echo "Usage: maketests.sh"
    exit 1
}

# Run <args>
# Report the command, run it, and report any errors
Run() {
    echo $* 1>&2
    eval $*
 #    eval $* ||
 #    {
	# SignalError "$1 failed on: $*"
	# return 1
 #    }
}

# RunFail <args>
# Report the command, run it, and expect an error
RunFail() {
    echo $* 1>&2
    eval $* && {
	SignalError "failed: $* did not report an error"
	return 1
    }
    return 0
}

# Check passing tests
MakeTest() {
    error=0
    basename=`echo $1 | sed 's/.*\\///
                             s/.gt//'`
    basedir="`echo $1 | sed 's/\/tests\/[^\/]*$//'`"
    # echo $basedir

    
    echo -e "\033[1m${basename}:\033[0m"

    echo 1>&2
    echo "###### Testing $basename" 1>&2
   
    tstfile="$1"

    refout="${basedir}/ref_stdout/${basename}.stdout"
    referr="${basedir}/ref_stderr/${basename}.stderr"
    refllvm="${basedir}/ref_llvm/${basename}.ll"
    refast="${basedir}/ref_ast/${basename}.ast"

    asmfile="${basedir}/tmp/${basename}.s"
    exefile="${basedir}/tmp/${basename}.exe"

    $GROOT -a $tstfile > $refast
    $GROOT -l $tstfile > $refllvm 2> $referr &&
    llc -relocation-model=pic $refllvm -o $asmfile 2> $referr &&
    cc $asmfile -o $exefile 2> $referr &&
    ./$exefile 1> $refout 2> $referr

}

TESTSET_DIR="testsets"

# For each file in the files list
for TESTSET in $TESTSET_DIR/*
do

    # printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '\d196'
    printf '%.s─' $(seq 1 $(tput cols))
    printf "Generating Testset: $TESTSET\n\n"

    rm -rf $TESTSET/!(tests)
    mkdir -p "${TESTSET}/ref_stdout"
    mkdir -p "${TESTSET}/ref_stderr"
    mkdir -p "${TESTSET}/ref_llvm"
    mkdir -p "${TESTSET}/ref_ast"
    mkdir -p "${TESTSET}/tmp"

    for TEST in $TESTSET/tests/*.gt
    do
        MakeTest $TEST 2>> $globallog
    done

    rm -rf $TESTSET/tmp
done

exit $globalerror
