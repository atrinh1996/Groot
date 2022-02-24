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

make -q clean
make -q toplevel.native

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
    echo diff -b $1 $2 ">" $3 1>&2
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
	SignalError "$1 failed on $*"
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
    basedir="`echo $1 | sed 's/\/[^\/]*$//'`/"

    # Make stdout, stderr, and diff if not yet created
    mkdir -p "${basedir}/stdout"
    mkdir -p "${basedir}/diff"
    
    echo -e "\033[1m${basename}:\033[0m"

    echo 1>&2
    echo "###### Testing $basename" 1>&2
   
    tstfile="$1"
    reffile="${basedir}ref/${basename}.ref"
    outfile="${basedir}stdout/${basename}.out"
    diffile="${basedir}diff/${basename}.diff"

    genfiles=""

    # Run the diff tests, store generated files
    genfiles="$genfiles ${diffile} ${outfile}" &&
    Run "$GROOT" "$tstfile" ">" "${outfile}" &&
    Compare ${outfile} ${reffile} ${diffile}

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
    basedir="`echo $1 | sed 's/\/[^\/]*$//'`/"

    # Make stdout, stderr, and diff if not yet created
    mkdir -p "${basedir}/stderr"
    mkdir -p "${basedir}/diff"

    echo -e "\033[1m${basename}:\033[0m"

    echo 1>&2
    echo "###### Testing $basename" 1>&2

    tstfile="$1"
    reffile="${basedir}ref/${basename}.ref"
    errfile="${basedir}stderr/${basename}.err"
    diffile="${basedir}diff/${basename}.diff"

    genfiles=""

    genfiles="$genfiles ${diffile} ${errfile}" &&
    RunFail "$GROOT" "$tstfile" "2>" "${errfile}" &&
    Compare ${errfile} ${reffile} ${diffile}

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

if [ $# -ge 1 ]
then
    files=$@
else
    files="testfiles/test-*.gt testfiles/fail-*.gt"  # Default Test files
fi

# For each file in the files list
for file in $files
do
    case $file in
	*test-*)                                # Check passing tests - update log
	    Check $file 2>> $globallog
	    ;;
	*fail-*)                                # Check failing tests - update log
	    CheckFail $file 2>> $globallog
	    ;;
    */*)
	    ;;
	*)
	    echo "unknown file type $file"
	    globalerror=1
	    ;;
    esac
done

exit $globalerror
