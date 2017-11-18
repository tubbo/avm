#!/usr/bin/env bats

setup() {
  export AVM_DRY_RUN=true
}

@test "no arguments prints usage" {
  run bin/avm
  [ "${lines[0]}" = "Usage: avm SERVICE [VERSION] [OPTIONS]" ]
}

@test "docker not installed prints error" {
  DOCKER_COMMAND=foobar run bin/avm
  [ "${lines[0]}" = "Error: avm requires Docker to be installed." ]
}

@test "no version uses 'latest' image" {
  run bin/avm foo
  [ "${lines[0]}" = "docker image pull foo:latest" ]
}

@test "specify version" {
  run bin/avm foo 1.4.5
  [ "${lines[0]}" = "docker image pull foo:1.4.5" ]
}

@test "pass arguments through command" {
  run bin/avm foo 1.4.5 -p 9300:9300

  [ "${lines[1]}" = "docker run -p 9300:9300 foo:1.4.5" ]
}

@test "use arguments in file" {
  echo "-p 9200:9200" > ~/.avm/foo
  run bin/avm foo 1.4.5
  result="${lines[1]}"
  rm ~/.avm/foo

  [ "$result" = "docker run  foo:1.4.5" ]
}

@test "command arguments overrides file" {
  echo "-p 9200:9200" > ~/.avm/foo
  run bin/avm foo 1.4.5 -p 9300:9300
  result="${lines[1]}"
  rm ~/.avm/foo

  [ "$result" = "docker run -p 9300:9300 foo:1.4.5" ]
}
