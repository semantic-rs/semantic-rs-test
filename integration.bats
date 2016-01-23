#!/usr/bin/env bats

setup() {
  [ "$CI" = "true" ] && return
  cd $HOME/tmp
}

@test "it runs" {
  run semantic-rs
  [ "$status" -eq 1 ]
}

@test "fails without Cargo.toml" {
  cd fixtures/empty-dir
  run semantic-rs
  [ "$status" -eq 1 ]
}

@test "fails on non-git directories" {
  skip
  cd fixtures/not-a-repo
  run semantic-rs
  [ "$status" -eq 1 ]
}

@test "fails with broken Cargo.toml" {
  cd fixtures/broken-cargo-toml
  run semantic-rs
  [ "$status" -eq 1 ]
}

@test "Initializes to v1.0.0" {
  cd fixtures/initial-release
  git reset --hard master

  run semantic-rs
  [ "$status" -eq 0 ]
  run grep -q 'version = "1.0.0"' Cargo.toml
  [ "$status" -eq 0 ]
}

@test "Bumps to next minor" {
  cd fixtures/next-minor
  git reset --hard master

  run grep -q 'version = "1.0.0"' Cargo.toml
  [ "$status" -eq 0 ]

  run semantic-rs
  [ "$status" -eq 0 ]

  run grep -q 'version = "1.1.0"' Cargo.toml
  [ "$status" -eq 0 ]
}
