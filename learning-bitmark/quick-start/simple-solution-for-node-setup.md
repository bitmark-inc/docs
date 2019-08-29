#  [Learning Bitmark / Quick start] - Simple solution for node setup

### Start your bitmark-node
This section will quide you to start a bitmark docker node. The **docker** node, also called **bitmark-node**, is a bitmark full-node. A full-node can generate blocks, mine the blocks and do verification of payments. 

### Assumptions
+ [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) is installed in your system
+ [docker](https://docs.docker.com/install/) is installed in your system
    +  Windows user run docker on Hyper-V
+ you [log in](https://docs.docker.com/engine/reference/commandline/login/) your docker with [docker hub]((https://hub.docker.com/)) account
+ you have and know your **public IP** address
+ If you are behind a firewall, you know how to setup a **port-forwarding**
+ you have **a bitcoin and a litecoin address** for recieving mining reward

## Installation

### Step 0: Preparation
+ Have your **Public IP** ready
+ Setup port-forwarding if nessasary
    + port	**2136** for connecting to other peer bitmarkd nodes
    + port	**2135** for publishing blockchain events
    + port 	**2130** for Bitmark node RPC server


### Step 1: Download and Run Script

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

### Step 2: Run bitmarkd node and recorderd
+ Startup screen
    + Run bitmarkd by click "start button" of "Bitmark Node (bitmarkd)"
    + After bitmarkd is running, run a recorderd by click "start button" of "Recorder Node (recorderd)"
![startup screen](https://i.imgur.com/aeONALb.jpg)

+ Running screen
    + Wait untill 5 connections to establish a distribute network
    + "Current Block" shows progress of recieving blocks
    + "Your Blocks" shows the blocks that this account has won
![running screen](https://i.imgur.com/g9baqm8.jpg)


###### tags: 'bitmark-node' 'documentation' 'quick start' 'bitmark'
