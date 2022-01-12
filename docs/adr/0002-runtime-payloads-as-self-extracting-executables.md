# 2. Runtime Payloads as Self Extracting Executables

2022-01-11

## Status

Accepted

## Context

There are many projects who use OCI images for payloads of runtime images, user space binaries, etc. The benefits are 
you can store these in existing docker registeries and use existing tooling to pull/use them. There is a problem with
doing this in a windows environment as the tooling isn't as great especially for teams to use existing linux infrastructure
to create windows images. We want to avoid this problem by using self extracting executables using Go and wrapping some simple 
logic into the binary like listing, md5 checksums, etc. 

## Decision

We will use go1.16 embed functionality and create tooling to create self extracting executables from config. We will
create ci/cd pipelines to package up runtime binaries and a winkube release of a k8s version will be service config 
and a corresponding self extracting executable.

## Consequences

We can't store these executables in an OCI registry, but we could improve the tooling to offer a self extracting binary inside an image
and with host drive mounts and an entrypoint we could accomplish the same thing. We can always fall back to OCI images if we have too.
