#!/usr/bin/env bats

setup() {
  cd $HOME/workspace
  git config --global user.name "semantic-rs"
  git config --global user.email "semantic@rs"
}

teardown() {
  rm $HOME/.gitconfig
}

@test "it runs" {
  run semantic-rs
  [ "$status" -eq 1 ]
}

@test "fails without Cargo.toml" {
  cd empty-dir
  run semantic-rs
  [ "$status" -eq 1 ]
}

@test "fails on non-git directories" {
  cd not-a-repo
  run semantic-rs
  [ "$status" -eq 1 ]
}

@test "fails with broken Cargo.toml" {
  cd broken-cargo-toml
  run semantic-rs
  [ "$status" -eq 1 ]
}

@test "Initializes to v1.0.0" {
  cd initial-release
  mv git .git && git reset --hard master

  run semantic-rs
  [ "$status" -eq 0 ]
  run grep -q 'version = "1.0.0"' Cargo.toml
  [ "$status" -eq 0 ]
}

@test "Bumps to next minor" {
  cd next-minor
  mv git .git && git reset --hard master

  run grep -q 'version = "1.0.0"' Cargo.toml
  [ "$status" -eq 0 ]

  run semantic-rs
  [ "$status" -eq 0 ]

  run grep -q 'version = "1.1.0"' Cargo.toml
  [ "$status" -eq 0 ]
}

@test "No bump when no new commits" {
  cd no-bump
  mv git .git && git reset --hard master

  run grep -q 'version = "1.1.0"' Cargo.toml
  [ "$status" -eq 0 ]

  run semantic-rs
  [ "$status" -eq 0 ]
  [[ "$output" =~ "No version bump. Nothing to do" ]]

  run grep -q 'version = "1.1.0"' Cargo.toml
  [ "$status" -eq 0 ]
}
