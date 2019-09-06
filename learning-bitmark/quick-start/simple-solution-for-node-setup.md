#  [ Learning Bitmark / Quick start ] - Simple solution for node setup

## Start your bitmark node

A user can run a bitmark node in several ways. This section will guide you to start a bitmark node using docker container. Inside a bitmark node docker container, there are bitmarkd, recorderd, payment system and a user interface to control and monitor services.

## Prerequisites

+ [docker](https://docs.docker.com/install/) is installed in your system
    +  Windows user run docker on Hyper-V
+ you [log in](https://docs.docker.com/engine/reference/commandline/login/) your docker with [docker hub]((https://hub.docker.com/)) account
+ you have and know your **public IP** address
+ you have **a bitcoin and a litecoin address** for receiving mining reward
+ you may need to setup your network to allow other bitmark nodes to communicate with your bitmark node. You can check more information on "Important Notice On Network" below.

## Installation

### Step 0: Preparation
+ Have your **Public IP** ready
+ Make sure following ports are accessible from internet
    + port	**2136** for connecting to other peer bitmarkd nodes
    + port	**2135** for publishing blockchain events
    + port 	**2130** for Bitmark node RPC server

You can check more information on "Important Notice On Network" below.


### Step 1: Download and Run Script

Downloaded script will help you to manage bitmark node container. The  installation of the script will pull down a latest bitmark node container image from docker hub and then start a bitmark node container for you.  To check what functions the script supports and how to run it, simply run ``` bash install-node-linux-mac.sh```.  or ```bitmarkNode-HyperV.bat```.


+  Linux and mac users
    + [download scripts for linux and mac](https://bitmark-node-docker-scripts.s3-ap-northeast-1.amazonaws.com/install-node-linux-mac.sh)
    + execute bash install-node-linux-mac.sh [Your Public IP]. When run the script without providing [Your Public IP], the script will find your IP from Internet

        ```bash install-node-linux-mac.sh 123.123.123.123```
    + follow script instruction and select "1)Installation"

    
+  Windows users
    +  ensure that Hyper-V is turned on
    +  [download script for windows](https://s3-ap-northeast-1.amazonaws.com/bitmark-node-docker-scripts/bitmarkNode-HyperV.bat)
    + execute bitmarkNode-HyperV.bat [Your Public IP]. When run the script without providing [Your Public IP], the script find your IP from Internet

        ``` bitmarkNode-HyperV.bat 117.166.111.123```
    + follow script instruction and select "1)Installation"
+ execute **docker ps** in your command-line/shell to check if bitmark-node is running
![docker ps result](https://i.imgur.com/l3dF4Hl.jpg)

## Management Panel

### Step 1: Open A Node-Management Webpage 
+ view our node-mangement webpage on http://127.0.0.1:9980 in a browser
+ input your BTC and LTC address for rewarding in a pop-up screen
![Input your BTC&LTC Address](https://i.imgur.com/IRTlyjY.jpg?1)

### Step 2: Run bitmarkd and recorderd
+ startup screen
    + run bitmarkd by click "start button" of "Bitmark Node (bitmarkd)"
    + after bitmarkd is running, run a recorderd by click "start button" of "Recorder Node (recorderd)"
    +  if you don't want to use your machine to help us on mining, you can stop recorderd.

![startup screen](https://i.imgur.com/aeONALb.jpg)

+ Running screen
    + wait until 5 connections to establish a distribute network
    + "Current Block" shows progress of receiving blocks
    + "Your Blocks" shows the blocks that this account has won

![running screen](https://i.imgur.com/g9baqm8.jpg)

## Important Notice On Network

User must ensure the following ports to be accessible from Internet.

| PORT | DESCRIPTION                                     |
|------|--------------------------------------------------|
| 2136 | Port for connecting to other peer bitmarkd nodes |
| 2135 | Port for publishing blockchain events            |
| 2130 | Port for Bitmark node RPC serve                  |
When running bitmark node container, user can make sure ports are opened with the following commands.

netcat -v [Your Public IP] 2136

netcat -v [Your Public IP] 2135

netcat -v [Your Public IP] 2130

WebUI is an interface to control bitmark node services. User can only access WebUI through local network. Please notice that user can not access the port from internet due to security reason.

| PORT | DESCRIPTION                |
|------|----------------------------|
| 9980 | Web server port for web UI |

###### tags: 'bitmark-node' 'documentation' 'quick start' 'bitmark'
