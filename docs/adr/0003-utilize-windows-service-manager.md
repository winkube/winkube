# 3. Utilize Windows Service Manager

2022-01-11

## Status

Accepted

## Context

Windows Service Manager is available with a stable api on all versions of Windows Server we will be supporting. In lieu of writing our own
daemon or using static pods we will use what's given to us already. This is especially important for the edge as the feelings are not adding
extra overhead with our own code.

## Decision

Use Windows Service Manager to run all aspects of winkube's services. We will provide config to winkube to spin up these services and  
 offer tooling into logs and start/stop/upgrade of these services.

## Consequences

All these services will be running on the host as services and not in containers. This is intentional as for the 
windows use case we feel it's the most easily managed and create the least amount of overhead for the edge solution.
