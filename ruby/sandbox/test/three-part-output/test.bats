TEST_NAME=`basename $BATS_TEST_DIRNAME`

function setup {
  source $BATS_TEST_DIRNAME/../../../../common/sandbox/test/setup.sh
}

function teardown {
  source $BATS_TEST_DIRNAME/../../../../common/sandbox/test/teardown.sh
}

@test "$TEST_NAME: Output is JSON object with 3 pairs." {
    r=$(echo $OUT | jshon -l)
    [ "$r" = 3 ]
}

@test "$TEST_NAME: Exit code is 0." {
    r=$(echo $OUT | jshon -e exitCode)
    [ "$r" = 0 ]
}

@test "$TEST_NAME: Wall time has right format." {
    r=$(echo $OUT | jshon -e wallTime -u)
    grep '^[0-9]:[0-9][0-9]\.[0-9][0-9]$' <<<"$r"
}

@test "$TEST_NAME: Actual output is expected output." {
    r="$(echo "$OUT" | jshon -e actualOutput)"
    e="\"this is line 1\nthis is line 2\n\""
    [ "$r" = "$e" ]
}

@test "$TEST_NAME: Sandbox is not running after run-sandbox.sh exits." {
  ! docker ps | grep $CID
}
