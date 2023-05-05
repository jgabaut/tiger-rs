#!/bin/bash
prog_name="$0"

function echo_run() {
  echo -e "    [CMD]  $@"
}

function build_tests() {
  echo "    [BUILD] Building tests"
  for F in ${files[*]}; do
    echo_run "./tiger tests/$F.tig"
    ./tiger "tests/$F.tig"
  done
  for F in ${skip_files[*]}; do
    echo_run "./tiger tests/$F.tig [SKIP TEST]"
    ./tiger "tests/$F.tig"
  done
}

function delete_tests() {
  echo "    [DELETE] Deleting tests"
  for F in ${files[*]}; do
    echo_run "rm -f tests/$F"
    rm -f "tests/$F"
  done
  #for F in ${skip_files[*]}; do
  #  echo_run "rm -f tests/$F [SKIP TEST]"
  #  rm -f "tests/$F"
  #done
}

(( i = 1 ))

all_files=(array array_assignment comments conditions escapes functions gc hello hello1 hello2 hello3 hello5 integers lib loops merge nested prettyprint queens record spill strings vars)
skip_files=(array array_assignment gc hello3 hello5 lib merge prettyprint queens record strings)
files=(comments conditions escapes functions hello hello1 hello2 integers loops nested spill vars)

function echo_options {
  echo -en "        -a       all\n"
  echo -e "                Tries all tests."
  echo -en "        -b        build\n"
  echo -e "                Tries building selected tests."
  echo -en "        -d        delete\n"
  echo -e "                Deletes all tests."
  echo -en "        -v        verbose\n"
  echo -e "                More output."
  echo -en "        -h        help\n"
  echo -e "                Print this message."
}

function usage {
  echo -e "Usage: $(basename $prog_name) [OPTION]\n"
  echo_options
}

#Prepare flag values to default value
build_flag=0
delete_flag=0
verbose_flag=0
help_flag=0
all_tests_flag=0

while getopts "bvdah" opt; do
  case $opt in
    a )
      all_tests_flag=1
      ;;
    d )
      delete_flag=1
      ;;
    b )
      build_flag=1
      ;;
    v )
      verbose_flag=1
      ;;
    h )
      help_flag=1
      ;;
    * )
      usage
      exit 1
      ;;
  esac
done

[[ $help_flag -gt 0 ]] && usage && exit 0

while (( $i < 2 )); do
    echo "******************************"
    echo "    Run $i:"
    echo "******************************"
    if [[ $delete_flag -gt 0 ]] ; then {
      delete_tests
      [[ $build_flag -eq 0 ]] && echo "    [Info] Quitting, no build flag after delete." && exit 0
    }
    fi
    [[ $build_flag -gt 0 ]] && build_tests

    export TIGER_GC_CAPACITY=$i
    if [[ $all_tests_flag -eq 0 ]] ; then {
      file_count=0
      for file in ${files[*]}; do
        file_count=$(($file_count + 1))
      done
      file_idx=0
      passed=0
      failed=0
      for file in ${files[*]}; do
          echo "    [Test] Testing $file [$file_idx/$file_count]"
	  if [ -f "tests/$file.stdin" ]; then
	      output=$("tests/$file" < "tests/$file.stdin" && printf X)
	  else
	      output=$("tests/$file" && printf X)
	  fi
	  # Add an X and then remove it so that it doesn't strip trailing newlines.
	  output=${output%X}
	  if ! diff <(printf "%s" "$output") "tests/$file.stdout"; then
	      diff -y <(printf "%s" "$output") "tests/$file.stdout"
	      echo "    [Test] $file : FAIL"
              failed=$(($failed + 1))
	  fi
	      echo "    [Test] $file : PASS"
              passed=$(($passed + 1))
        file_idx=$(($file_idx + 1))
      done
      echo "    [Test] [Passed]: $passed"
      echo "           [Failed]: $failed"
      echo -e "\n    [Test] Run with -a to run all tests."
      echo "    [Test] Done testing selected files, quitting."
      exit 0
    }
    fi
    file_count=0
    for file in ${all_files[*]}; do
      file_count=$(($file_count + 1))
    done
    file_idx=0
    passed=0
    failed=0
    for file in ${all_files[*]}; do
        echo "    [Test] Testing $file [$file_idx/$file_count]"
        if [ -f "tests/$file.stdin" ]; then
            output=$("tests/$file" < "tests/$file.stdin" && printf X)
        else
            output=$("tests/$file" 2>/dev/null && printf X)
        fi
        # Add an X and then remove it so that it doesn't strip trailing newlines.
        output=${output%X}
        if ! diff -q <(printf "%s" "$output") "tests/$file.stdout" ; then {
            #diff -y <(printf "%s" "$output") "tests/$file.stdout"
            echo "    [Test] $file : FAIL"
            failed=$(($failed + 1))
        } else {
            echo "    [Test] $file : PASS"
            passed=$(($passed + 1))
        }
        fi
      file_idx=$(($file_idx + 1))
    done
    echo "    [Test] [Passed]: $passed"
    echo "           [Failed]: $failed"
    (( i = i + 1 ))
done
