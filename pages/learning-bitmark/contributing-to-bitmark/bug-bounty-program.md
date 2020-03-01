---
title: Bug Bounty Program
keywords: bug bounty
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/contributing-to-bitmark/bug-bounty-program
folder: learning-bitmark/contributing-to-bitmark
---

# Bug Bounty Program

Bitmark strives to make the Bitmark Property System safe and secure for everyone. We greatly value the work done by security researchers in improving the security of our products and service offerings, so we are committed to working with this community to verify, reproduce, and respond to legitimate reported vulnerabilities. We encourage the community to participate in our responsible reporting process.

**Important:** We only accept bug reports for the **`bitmarkd`** project. Bug reports for web applications or any other project that is not **`bitmarkd`** will not be accepted nor given any reward.

[SUBMIT A BUG](https://docs.google.com/forms/d/e/1FAIpQLSeVzZfd-DDQNuVVDMkwgu4VSxmPnvB6OLo_sw_9CH1w34xoZA/viewform)

We offer rewards in Bitcoin:

| Critical | High    | Medium  | Low     | Note     |
|----------|---------|---------|---------|----------|
| 1 BTC     | 0.5 BTC | 0.2 BTC | 0.1 BTC | 0.01 BTC |

Latest bug updates:
* **2018.11.14**: Congratulations to bughunterboy for finding bugs and earning rewards!
* **2018.10.11**: Join our Bug Bounty Program and earn rewards now!

## How to report a bug

### Determining scope
[Bitmarkd](https://github.com/bitmark-inc/bitmarkd) is the codebase for the Bitmark blockchain.

##### Bug scope
Only bugs in Scope are eligible for a bug bounty. A qualifying bug has to be a danger to the blockchain records, privacy, or client operations. These include bugs in:
1. **Protocol**: Flaws in protocol design, an example being the incentive design flaw in the [white paper](https://bitmark.com/assets/bitmark_technical-white-paper.pdf)
2. **Implementation of client**: Any implementation bug in `bitmarkd` that could cause cause bad block, invalid assets, transaction failure, bad operations, or program crashes
3. **Cryptography**: Incorrect implementation of Cryptographic algorithms
4. **Network Attacks**: Attacks such as Sybil attacks
5. Any bugs that Bitmark considers important

###### Restrict online low-bandwidth attack to these two nodes only:
* `node-d3.test.bitmark.com`
* `node-a3.test.bitmark.com`

##### Bugs in third-party packages
Third-party package bugs may or may not be rewarded by Bitmark. In theory, you should claim the bug(s) directly with a third-party bounty program; however, we may also reward you for your efforts.

##### Out-of-scope bugs
Bugs that are out of scope include those that require:
* Physical access to a user’s device
* Social engineering
* MITM attacks
* DDoS / Fuzzing / High-Bandwidth Attack

### Submitting a bug
* Submit your report to: [Bug Bounty Submission Form](https://docs.google.com/forms/d/e/1FAIpQLSeVzZfd-DDQNuVVDMkwgu4VSxmPnvB6OLo_sw_9CH1w34xoZA/viewform)

### Collecting rewards
Rewards are considered based on the impact and severity of the vulnerability, with relation to the scope and quality of the report. 

* Critical Bugs: key leaks
* High Bugs (At Least): invalid block or corrupted database
* If a bug does not fit into the Critical or High criteria as defined above, it will be considered Medium, Low, or Note

* Only unknown and first-submitted bugs are considered eligible for a reward
* A detailed proof of concept has to be presented when claiming a Critical or High bug

## Disclosure policy
Please discuss with us before disclosure of your bugs. Bitmark will endeavor to respond to reports within **2-3 business days** and will make every effort to quickly address reported vulnerabilities. To encourage responsible reporting, we commit that we will **not take legal action** against you or ask law enforcement to investigate you if you give us at least **90 days** from the time of your report to correct the issue before you make the reported vulnerability public.

[CONTACT US](mailto:security@bitmark.com)

#### For more info
Read our [Governance policy](https://bitmark.com/en/legal/governance-policy), or view the [Bitmark GitHub](https://bitmark.com/en/developers/github) repo if you are interested in contributing code.
