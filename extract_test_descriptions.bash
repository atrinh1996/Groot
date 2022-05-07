#~!/bin/bash

# Zachary Goldstein
# run this to extract all test descriptions

NUMTESTS=0

ExtractDescription() {
	TEST_PATH=$1

	TEST_NAME=$(echo $1 | sed 's/^.*\///;s/.gt//')
	DESCRIPTION=$(cat $TEST_PATH | head -n 1 | sed 's/...//')
	
	printf '\t- %-20s : %s\n' "$TEST_NAME" "$DESCRIPTION"

	NUMTESTS=$((NUMTESTS + 1))


}

TESTSET_DIR="testsets"

# For each testset in the testset directory
for TESTSET in $TESTSET_DIR/*
do

    TESTSET_NAME=$(echo $TESTSET | sed 's/^[^/]*\///' | cut -d/ -f1)
    # printf '%.s─' $(seq 1 $(echo 80)) # better for terminals
    printf '\n\n---\n\n' #better for markdown
    printf "\nTestset: $TESTSET_NAME\n\n"   

    for TEST in $TESTSET/tests/*.gt
    do
        ExtractDescription $TEST
    done

done

1>&2 echo "Extracted descriptions for $NUMTESTS tests."