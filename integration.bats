#!/usr/bin/env bats

@test "it runs" {
  run semantic-rs
  [ "$status" -eq 1 ]
}
