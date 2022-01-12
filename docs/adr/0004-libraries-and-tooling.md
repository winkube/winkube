# 4. Libraries and Tooling

2022-01-11

## Status

Accepted

## Context
A list of packages/tooling and repo management decisions and why we decided to make that decision.

## Decision
* We will fix and consume upstream wherever possible and be good stewards of open source software and it's community
* (cobra)[https://github.com/spf13/cobra] (viper)[https://github.com/spf13/cobra] - Upstream k8s uses these pretty heavily and to maximize contributions we will too
* (testify)[https://github.com/stretchr/testify] - We want as much testing as possible and we agreed as a team we were the most comfortable with testify
* (goreleaser)[https://goreleaser.com/] - all the tooling we'll ever need for building releases
* (mage)[https://magefile.org/] - To alleviate windows issues we want as much native go building/making
* github actions - no reason to use anything more powerful for now
* We DONT want a pkg directory...
* Nightly Functional Tests - Spin up and run sonobuoy and other tests against clusters every night for regression detection

## Consequences

Time will tell...
