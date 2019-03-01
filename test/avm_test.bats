#!/usr/bin/env bats

load test_helper

setup() {
  export AVM_DRY_RUN=true
}

@test "no arguments prints usage" {
  run bin/avm

  assert_failure
  assert_line "Usage: avm SERVICE [VERSION] [OPTIONS]"
}

@test "docker not installed prints error" {
  DOCKER_COMMAND=foo run bin/avm

  assert_failure
  assert_line "Error: avm requires Docker to be installed."
}

@test "no version uses 'latest' image" {
  run bin/avm foo

  assert_success
  assert_line "docker image pull foo:latest"
}

@test "specify version" {
  run bin/avm foo 1.4.5

  assert_success
  assert_line "docker image pull foo:1.4.5"
}

@test "pass arguments through command" {
  run bin/avm foo 1.4.5 -p 9300:9300

  assert_success
  assert_line "docker run --rm -it -p 9300:9300 foo:1.4.5"
}

@test "use arguments in file" {
  echo "-p 9200:9200" > $HOME/.avm/foo
  run bin/avm foo 1.4.5
  rm ~/.avm/foo

  assert_success
  assert_line "docker run --rm -it -p 9200:9200 foo:1.4.5"
}
