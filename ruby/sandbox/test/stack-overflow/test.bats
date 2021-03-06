TEST_NAME=`basename $BATS_TEST_DIRNAME`

function setup {
  source $BATS_TEST_DIRNAME/../../../../common/sandbox/test/setup.sh
}

function teardown {
  source $BATS_TEST_DIRNAME/../../../../common/sandbox/test/teardown.sh
}

@test "$TEST_NAME: Output is JSON object with 3 pairs." {
  r=$(echo $OUT | jshon -l)
  [ "$r" -ge 3 ]
}

@test "$TEST_NAME: Exit code is 1." {
  r=$(echo $OUT | jshon -e exitCode)
  [ "$r" = 1 ]
}

@test "$TEST_NAME: Wall time has right format." {
  r=$(echo $OUT | jshon -e wallTime -u)
  grep '^[0-9]:[0-9][0-9]\.[0-9][0-9]$' <<<"$r"
}

@test "$TEST_NAME: Actual output is expected output." {
  r=$(echo $OUT | jshon -e actualOutput -u | head -n 1)
  e="/tmp/program:2:in \`this_wont_end_well': stack level too deep (SystemStackError)"
  [ "$r" = "$e" ]
}

@test "$TEST_NAME: Sandbox is not running after run-sandbox.sh exits." {
  ! docker ps | grep $CID
}
