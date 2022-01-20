# 5. Configuration File

2022-01-20

## Status

Proposed

## Context

We want as much configuration of winkube to be powered by a large YAML document as it helps avoid lots of cli flags. 
We've decided on Viper which will use go types to parse a config file which will help keep things simple. This aligns
with upstream dropping flags and putting effort into a large config file.

## Decision

The winkube config file will be an amalgamation of all pieces needed to stand up kubernetes nodes. Each
node in the cluster can run a command like `winkube start -c ./v1.21.4.yaml --etcd --controlplane --worker` for all
roles or `winkube start -c ./v1.21.4.yaml --worker` for a worker node.

We plan to start from go types to generate Cue files. Those will be combined with data points to create a YAML config
file for each version of kubernetes we will support. Winkube itself will wholesale include the types and use Viper to
unmarshal into a variable.

We want to keep features locked behind top level keys of the document and a versioning structure that keeps the YAML file
an on going living document. If you want to add features put the config behind a key and bump the version number, if 
winkube supports that key in the YAML config we will execute those features.

The first feature we intend to support will be the `components` key which will be our services engine. As we add more
features and keys we may redefine the structure/versioning but today this will get us started.

## Consequences

* Tooling will need to be created around Cue + data to generate these config files
* Features may need include multiple yaml keys... we might have to redefine the structure