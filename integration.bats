#!/usr/bin/env bats

setup() {
  [ "$CI" = "true" ] && return
  [ -d "semantic-rs" ] || git clone https://github.com/semantic-rs/semantic-rs
  pushd semantic-rs
  git pull
  cargo build
  popd
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
  run semantic-rs
  [ "$status" -eq 0 ]
  run grep -q 'version = "1.0.0"' Cargo.toml
  [ "$status" -eq 0 ]
}
