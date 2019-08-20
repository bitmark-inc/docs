# Overview

This paragraph describes how mining works, how mining program communicates with `bitmarkd`, what kind of protocl it used, and how is miner rewarded.

# Block Diagram

            +--------------+  zero mq protocal   +---------------+
            |              |  ---------------->  |               |
            |   bitmarkd   |                     |   recorderd   |
            |              |  <----------------  |               |
            +--------------+  zero mq protocal   +---------------+

The hashing procedure relates to `bitmarkd` and `recorderd`. `recorderd` is the program to perform hashing, it receives messages from `bitmarkd` and tries to find hashes possibly meets hashing criteria, if any possible hash is found, `recorderd` sends message back to `bitmarkd` to ask for validation.

When `bitmarkd` receives hash from `recorderd`, `bitmarkd` validates hashing task returned is valid (which means the task is sent from this `bitmarkd` node but not other `bitmarkd` node), the hash is valid. After validating hash correctness, `bitmarkd` sends result bask to `recorderd`.

If `bitmarkd` receives no valid hashes from other nodes or from `recorderd`, `bitmarkd` sends hashing task to `recorderd` every 1 minute until valid hash is received.
