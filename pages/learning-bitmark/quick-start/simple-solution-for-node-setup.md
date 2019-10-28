---
title: Run a Bitmark Node
keywords: node setup
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/quick-start/simple-solution-for-node-setup
folder: learning-bitmark/quick-start
---

# Run a Bitmark Node

## Start your Bitmark Node

There are several way to run a Bitmark Node. A user can install services like bitmarkd, discovery and recorderd base on their own interested.  To install those services, the user needs to configure the settings and install dependencies before running each service. For the first time user,  a  docker container with a bitmark node and miner services is the quickest and easiest way to start with bitmark node.  We have setup environment and run  services  for users.

This section will guide you to start a bitmark node using docker container. Inside a bitmark node docker container, there are bitmarkd, recorderd, payment system and a user interface to control and monitor services.

## Prerequisites

+ [Docker](https://docs.docker.com/install/) is installed in your system
    +  Windows user run docker on Hyper-V
+ You [log in](https://docs.docker.com/engine/reference/commandline/login/) your docker with [docker hub]((https://hub.docker.com/)) account
+ You have and know your **public IP** address
+ You have **a bitcoin and a litecoin address** for receiving mining reward
+ Your environment is open for incoming connections through port 2136.  


## Installation

Downloaded script will help you to manage bitmark node container. The  installation of the script will pull down a latest bitmark node container image from docker hub and then start a bitmark node container for you.  To check what functions the script supports and how to run it, simply run ``` bash install-node-linux-mac.sh``` on linux or mac.  or ```bitmarkNode-HyperV.bat``` on windows.


+  Linux and mac users
    + [Download scripts for linux and mac](https://bitmark-node-docker-scripts.s3-ap-northeast-1.amazonaws.com/install-node-linux-mac.sh)
    + Execute bash install-node-linux-mac.sh [Your Public IP]. When run the script without providing [Your Public IP], the script will find your IP from Internet

        ```bash install-node-linux-mac.sh  <Your Public IP>```
    + Follow script instruction and select "1)Installation"

    
+  Windows users
    +  Ensure that Hyper-V is turned on
    +  [Download script for windows](https://s3-ap-northeast-1.amazonaws.com/bitmark-node-docker-scripts/bitmarkNode-HyperV.bat)
    + Execute bitmarkNode-HyperV.bat [Your Public IP]. When run the script without providing [Your Public IP], the script find your IP from Internet

         ``` bitmarkNode-HyperV.bat 117.166.111.123```
    + Follow script instruction and select "1)Installation"
+ Execute docker ps in your command-line/shell to check if bitmark-node is running
![docker ps result](https://i.imgur.com/l3dF4Hl.jpg)

## Management Panel

### Step 1: Open A Node-Management Webpage 
+Access the node management webpage at http://127.0.0.1:9980
+ Input your BTC and LTC address for rewarding in a pop-up screen
![Input your BTC&LTC Address](https://i.imgur.com/IRTlyjY.jpg?1)

+ Notice: WebUI is an interface to control bitmark node services. User can only access WebUI through local network. Please notice that user can not access the port from internet due to security reason.
### Step 2: Run bitmarkd and recorderd
+ Startup screen
    + Run bitmarkd by click "start button" of "Bitmark Node (bitmarkd)"
    + After bitmarkd is running, run a recorderd by click "start button" of "Recorder Node (recorderd)"
    +  If you don't want to use your machine to help us on mining, you can stop recorderd.

![startup screen](https://i.imgur.com/aeONALb.jpg)

+ Running screen
    + Wait for 5 connections to establish a distribute network
    + The "Current Block" shows the progress of blocks synchronization of the node
    + "Your Blocks" shows the blocks that this account has won

![running screen](https://i.imgur.com/g9baqm8.jpg)

If block does not start to  synchronize  with remote bitmark node over 20 minutes, check your network. Also see [Important Notice On Network](#important-notice-on-network)

## Important Notice On Network

User must ensure the following ports to be accessible from Internet.

| PORT | DESCRIPTION                                     |
|------|--------------------------------------------------|
| 2136 | Port for connecting to other peer bitmarkd nod      |

When running bitmark node container, user can make sure ports are opened with the following command in Linux and Mac.

netcat -v [Your Public IP] 2136

For windows users, telnet can be used to test on an open port.

telnet [Your Public IP] 2136