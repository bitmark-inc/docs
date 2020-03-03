---
title: Running a Bitmark Node
keywords: node setup
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/quick-start/simple-solution-for-node-setup
folder: learning-bitmark/quick-start
---

# Running a Bitmark Node

There are many ways to interact with the Bitmark blockchain. Some of them, such as using the [Bitmark App](https://a.bitmark.com/), are extremely easy and accessible. However, users who want the deepest interactions with the Bitmark blockchain will probably want to run their own Bitmark Node, which will grant them immediate, local access to the blockchain, and which can also give them the ability to act as a recorder, if desired.

## Starting your Bitmark Node

There are several way to run a Bitmark Node: services such as `bitmarkd`, `discovery` and `recorderd` can each be installed, based on a user's specific interest. A user will need to configure specific settings and install dependencies before running each service. For the first-time user, a docker container with a bitmark node and miner services is the quickest and easiest way to get started.

This section will guide you through the installation of a bitmark node using a docker container. The bitmark node docker container includes `bitmarkd`, `recorderd`, a payment system, and a user interface to control and monitor the services.

If you prefer, you can install a Bitmark Node [by hand](../..//bitmark-references/node-setup/bitmark-node-setup.md), as detailed in the [Bitmark References](../../bitmark-references).

## Prerequisites

+ [Docker](https://docs.docker.com/install/) must be installed on your system.
    +  Windows users must run docker on Hyper-V.
+ You must [log in](https://docs.docker.com/engine/reference/command line/login/) to your docker with a [docker hub]((https://hub.docker.com/)) account.
+ You must have and know your **public IP** address.
+ You must have **a bitcoin and a litecoin address** for receiving mining rewards.
+ Your environment must be open for incoming connections through port 2136.  


## Installing Your Bitmark Node

A downloadable script will help you to install your Bitmark node. This script will pull down the latest bitmark node container image from docker hub and then will start a bitmark node container for you. 
 
+  Linux and mac users:
    + [Download the scripts for Linux and Mac](https://bitmark-node-docker-scripts.s3-ap-northeast-1.amazonaws.com/install-node-linux-mac.sh)
    + Execute `bash install-node-linux-mac.sh [Your Public IP]`. (If you run the script without providing [Your Public IP], the script will find your IP from Internet.)

        ```bash install-node-linux-mac.sh  <Your Public IP>```
    + Follow the script instruction and select "1) Installation"

    
+  Windows users:
    +  Ensure that Hyper-V is turned on
    +  [Download the script for Windows](https://s3-ap-northeast-1.amazonaws.com/bitmark-node-docker-scripts/bitmarkNode-HyperV.bat)
    + `Execute bitmarkNode-HyperV.bat [Your Public IP]`. (If you run the script without providing [Your Public IP], the script will find your IP from Internet.)

         ``` bitmarkNode-HyperV.bat <Your Public IP>```
    + Follow the script instruction and select "1) Installation"
    
+  After installation:
    + Execute `docker ps` in your command-line/shell to check if bitmark node is running
![docker ps result](https://i.imgur.com/l3dF4Hl.jpg)

## Using the Management Panel

Following installation, you will be able to manipulate the Bitmark daemons directly from WebUI, a node-management web page.

### Step 1: Opening A Node-Management Web page 
+ Access the node management web page at http://127.0.0.1:9980
+ Input your BTC and LTC address for receiving mining rewards in a pop-up screen
![Input your BTC&LTC Address](https://i.imgur.com/IRTlyjY.jpg?1)

+ Notice: WebUI is an interface for controlling Bitmark node services. Users can only access it through a local network. The WebUI port cannot be  accessed from the internet due to security reasons.
### Step 2: Running bitmarkd and recorderd
+ On the start screen:
    + Run `bitmarkd` by clicking the "start button" for "Bitmark Node (bitmarkd)"
    + After `bitmarkd` is running, run a `recorderd` by clicking the "start button" for "Recorder Node (recorderd)"
    +  If you don't want to use your machine to help Bitmark with mining, don't run the `recorderd`

![start screen](https://i.imgur.com/aeONALb.jpg)

+ After the daemons are running:
    + Wait for five connections, to establish a distributed network
    + The "Current Block" window shows the progress of the node's block synchronization
    + The "Your Blocks" window shows the blocks that this account has won

![running screen](https://i.imgur.com/g9baqm8.jpg)

If blocks do not start to  synchronize with remote Bitmark nodes within 20 minutes, check your network. Also see [Important Notice On Network](#important-notice-on-network)

## Important Notice On Network

For your Blockchain node to work, you must ensure that the following ports are accessible from tie Internet.

| PORT | DESCRIPTION                                     |
|------|--------------------------------------------------|
| 2136 | Port for connecting to other bitmarkd nodes      |

Linux and Mac users can open this port with the following command:

```$netcat -v [Your Public IP] 2136```

Windows users can use `telnet` to test that a port is open:

telnet [Your Public IP] 2136
