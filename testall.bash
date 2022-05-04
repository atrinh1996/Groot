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

shopt -s extglob

# make clean
# make toplevel.native

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
    echo "Usage: testall.sh [options] [.mc files]"
    echo "-k    Keep intermediate files"
    echo "-h    Print this help"
    exit 1
}

SignalError() {
    if [ $error -eq 0 ] ; then
    	echo -e "  \033[31mI am groot...\033[0m"
    	error=1
    fi
    echo -e "    \033[31m${1}\033[0m"
}

# Compare <outfile> <reffile> <difffile>
# Compares the outfile with reffile.  Differences, if any, written to difffile
Compare() {
    genfiles="$genfiles $3"
    echo "diff -b $1 $2 > $3 1>&2"
    diff -b "$1" "$2" > "$3" 2>&1 || {
	   SignalError "$1 differs"
	   echo "FAILED $1 differs from $2" 1>&2
    }
}

# Run <args>
# Report the command, run it, and report any errors
Run() {
    echo $* 1>&2
    eval $* || {
    	SignalError "$1 failed on: $*"
    	return 1
    }
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
Check() {
    error=0
    basename=`echo $1 | sed 's/.*\\///
                             s/.gt//'`
    basedir="`echo $1 | sed 's/\/tests\/[^\/]*$//'`"

    # Make stdout, stderr, and diff if not yet created
    # mkdir -p "${basedir}/stdout"
    # mkdir -p "${basedir}/ast"
    # mkdir -p "${basedir}/diff"
    # mkdir -p "${basedir}/llvm"
    # mkdir -p "${basedir}/exe"
    # mkdir -p "${basedir}/stderr"
    
    echo -e "\033[1m${basename}:\033[0m"

    echo 1>&2
    echo "###### Testing $basename" 1>&2
   
    tstfile="$1"

    refout="${basedir}/ref_stdout/${basename}.stdout"
    referr="${basedir}/ref_stderr/${basename}.stderr"
    refllvm="${basedir}/ref_llvm/${basename}.ll"
    refast="${basedir}/ref_ast/${basename}.ast"

    astfile="${basedir}/ast/${basename}.ast"
    llvmfile="${basedir}/llvm/${basename}.ll"
    asmfile="${basedir}/asm/${basename}.s"
    exefile="${basedir}/exe/${basename}.exe"
    outfile="${basedir}/stdout/${basename}.stdout"
    errfile="${basedir}/stderr/${basename}.stderr"

    diffile="${basedir}/diff/${basename}.diff"

    genfiles=""

    # Run the diff tests, store generated files
    genfiles="$genfiles ${diffile} ${outfile} ${errfile} ${astfile} ${llvmfile} ${asmfile} ${exefile}"
    Run "$GROOT" "-a" "$tstfile" ">" "${astfile}"
    Run "$GROOT" "-l" "$tstfile" ">" "${llvmfile}" "2>" "${errfile}"                    &&
    Run "llc" "-relocation-model=pic" "${llvmfile}" "-o" "${asmfile}" "2>" "${errfile}" &&
    Run "cc" "-o" "${basedir}/exe/${basename}" "${asmfile}" "2>" "${errfile}"           && 
    Run "./${basedir}/exe/${basename} > ${outfile}" "2>" "${errfile}"                   &&
    Compare ${astfile} ${refast} ${diffile}                                             &&
    Compare ${llvmfile} ${refllvm} ${diffile}                                           &&
    Compare ${outfile} ${refout} ${diffile}                                             &&
    Compare ${errfile} ${referr} ${diffile}                                             &&

    # Report the status and clean up the generated files
    if [ $error -eq 0 ] ; then
    	if [ $keep -eq 0 ] ; then
    	    rm -f $genfiles
    	fi
    	echo -e "  \033[92mI AM GROOT!\033[0m"
    	echo "###### SUCCESS" 1>&2
    else
    	echo "###### FAILED" 1>&2
    	globalerror=$error
    fi
}

# Check Failing Tests
CheckFail() {
    error=0
    basename=`echo $1 | sed 's/.*\\///
                             s/.gt//'`
    basedir="`echo $1 | sed 's/\/tests\/[^\/]*$//'`"

    echo -e "\033[1m${basename}:\033[0m"

    echo 1>&2
    echo "###### Testing $basename" 1>&2

    tstfile="$1"
    referr="${basedir}/ref_stderr/${basename}.stderr"
    stderr="${basedir}/stderr/${basename}.stderr"
    diffile="${basedir}/diff/${basename}.diff"

    genfiles=""

    genfiles="$genfiles ${diffile} ${stderr}" &&
    RunFail "$GROOT" -l "$tstfile" "2>" "${stderr}" &&
    Compare ${stderr} ${referr} ${diffile}

    # Report the status and clean up the generated files
    if [ $error -eq 0 ] ; then
    	if [ $keep -eq 0 ] ; then
    	    rm -f $genfiles
    	fi
    	echo -e "  \033[92mI AM GROOT!\033[0m"
    	echo "###### SUCCESS" 1>&2
    else
    	echo "###### FAILED" 1>&2
    	globalerror=$error
    fi
}

# Get arguments options
while getopts kh c; do
    case $c in
	k) # Keep intermediate files
	    keep=1
	    ;;
	h) # Help
	    Usage
	    ;;
    esac
done

shift `expr $OPTIND - 1`

# if [ $# -ge 1 ]
# then
#     files=$@
# else
#     files="testfiles/phase2/*.gt"  # Default Test files
# fi

TESTSET_DIR="testsets"
# echo "HERE"

# For each file in the files list
for TESTSET in $TESTSET_DIR/*
do
    echo $TESTSET
    WORKDIRS="stdout stderr llvm ast asm exe diff"

    for DIR in $WORKDIRS
    do
        rm    -rf $TESTSET/$DIR
        mkdir -p  $TESTSET/$DIR
        # echo $TESTSET/$DIR
    done
    # ls $TESTSET

    # mkdir -p "${TESTSET}/stdout"
    # mkdir -p "${TESTSET}/stderr"
    # mkdir -p "${TESTSET}/llvm"
    # mkdir -p "${TESTSET}/ast"
    # mkdir -p "${TESTSET}/asm"
    # mkdir -p "${TESTSET}/exe"
    # mkdir -p "${TESTSET}/diff"

    for TEST in $TESTSET/tests/*.gt
    do
        case $TEST in
    	*test-*)                                # Check passing tests - update log
    	    Check $TEST 2>> $globallog
    	    ;;
    	*fail-*)                                # Check failing tests - update log
    	    CheckFail $TEST 2>> $globallog
    	    ;;
        */*)
    	    ;;
    	*)
    	    echo "unknown file type $TEST"
    	    globalerror=1
    	    ;;
        esac
    done
done

exit $globalerror
