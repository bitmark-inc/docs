---
title: Contribute to the Protocol
keywords: governance, security program, Bitmark Upgrade Proposal
last_updated:
sidebar: mydoc_sidebar
permalink: /contribute-to-the-protocol
folder:
---


# Contribute to the Protocol
_Last updated: 24 FEB 2020_

[TOC]


## About the Bitmark Protocol

We expect you probably got here from https://bitmark.com.  But just in case you didn’t, the explanation of the Bitmark Protocol is here:

*   [https://new.bitmark.com/products/bitmark-protocol/faq](https://new.bitmark.com/products/bitmark-protocol/faq)
*   [https://bitmark.com/white-papers](https://bitmark.com/white-papers)

The Bitmark Protocol software project is the means by which the peer-to-peer network implements the Bitmark Protocol.

The core values of both Bitmark Inc. and the Bitmark Protocol software project are transparency and trust. The end goal of the Bitmark Protocol software project is to develop a means of establishing transparency and trust in digital property.

To that end, this document attempts to transparently establish the principles by which Bitmark Inc. provides the Bitmark Protocol to the community and invites community participation, with the hope of establishing trust in that community.


### About Bitmark Inc.

Bitmark Inc. is a venture-funded private company.  Current information regarding our funders is here: [https://bitmark.com/about](https://bitmark.com/about).  Bitmark Inc. has been to date the main developer of the Bitmark Protocol software project, and we will offer services and products which rely on it, but we don’t want to be the only people using it.  We think it can be useful to the wider community.

Just as the larger project of Bitmark Inc. and the Bitmark Protocol software project is a distributed peer-to-peer network for managing and claiming crypto property, we’d like the Bitmark Protocol software project to become a community project.


### Why not a Foundation?

Bitmark Inc. is a small company.  We simply don’t have the resources to establish and sustain a separate foundation to manage the Bitmark Protocol software project.  As we grow, we will continue to evaluate whether, between Bitmark Inc. and the community, there are adequate resources to establish and sustain a separate foundation for the development and maintenance of the Bitmark Protocol software project.


### Why the Internet Systems Consortium (“ISC”) License?

We chose a permissive license in order to allow the broadest possible set of uses for the Bitmark Protocol software project.  It also makes contribution easy – just license your contribution under the ISC License.  We may at some point revisit the licensing model based on the actual uses of the Bitmark Protocol software project and community input.


## Principles of Operation

Bitmark Inc. will maintain the primary code repository for the Bitmark Protocol software project and will retain primary development and maintenance responsibility.  We will also retain control of the code commit decisions, at least until a sufficiently strong community has arisen from which to select trusted code committers.

Bitmark Inc. will also provide one or more community moderators to guide the discussion about the project, again, at least until a sufficiently strong community has arisen from which to select trusted community moderators.

Bitmark Inc. will provide its reasons for all of its decisions regarding the Bitmark Protocol software project, including the direction it chooses for development, code commit decisions, and community management decisions.

The primary method of communication among the communities will be one or more mailing lists. This creates an archive of community conversations and allows asynchronous conversations.  Our expectations for behavior are here: https://bitmark.com/conduct.  Generally speaking, however, we expect our community members to conduct open and honest conversations, **_while always treating each other with respect and honoring the dignity of each individual participant_**.

We will over time evaluate the community to determine whether we have a sufficient number of active participants to establish additional roles for community members or to establish a more democratic mode of governance.

Our expectation is that only Bitmark employees speak for the organization for which they work, and even then, only within their scope of authority.  All other community members speak only for themselves.


### Bitmark Upgrade Proposals

A Bitmark Upgrade Proposal (BUP) is a design document providing information to the Bitmark community or describing a new feature for
Bitmark or its processes or environment. A BUP provides a concise technical specification of the feature and a rationale for it.

We have a repo at GitHub specifically for BUPs. We do not maintain it as part of the
Bitmark documentation [repository](https://github.com/bitmark-inc/docs) because we want that to be a clean
environment where developers are not distracted by other
repos.

For full access to all BUPs, please go to: [Bitmark Upgrade Proposal](https://github.com/bitmark-property-system/bups)

Please assume that everything you contribute intentionally to the Bitmark Protocol software project is public. This includes emails on public lists, wikis, other online discussions of all sorts, and software or documentation that you post to this website or our revision control repositories.  There may be cases where you are invited to share private information for various purposes, and denote that information as such. That information is subject to the privacy policy of Bitmark Inc., located here:  [https://bitmark.com/privacy](https://bitmark.com/privacy).  Similarly, other information collected by this website is subject to that privacy policy.

Although what participants disclose here is public, both community members and Bitmark Inc. are limited by intellectual property law in how the use of community member contributions. **_Bitmark Inc. only accepts voluntary contributions of software and documentation that are expressly licensed to Bitmark Inc. (or all comers) under the ISC license._**


## Security Program

Bitmark strives to make the Bitmark Property System safe and secure for everyone. We greatly value the work done by security researchers in improving the security of our products and service offerings, so we are committed to working with this community to verify, reproduce, and respond to legitimate reported vulnerabilities. We encourage the community to participate in our responsible reporting process.

**Important:** We only accept bug reports for the **`bitmarkd`** project. Bug reports for web applications or any other project that is not **`bitmarkd`** will not be accepted nor given any reward.

[SUBMIT A BUG](https://docs.google.com/forms/d/e/1FAIpQLSeVzZfd-DDQNuVVDMkwgu4VSxmPnvB6OLo_sw_9CH1w34xoZA/viewform)

We offer rewards in Bitcoin:

| Critical | High    | Medium  | Low     | Note     |
|----------|---------|---------|---------|----------|
| 1 BTC    | 0.5 BTC | 0.2 BTC | 0.1 BTC | 0.01 BTC |

Latest bug updates:
* **2018.11.14**: Congratulations to bughunterboy for finding bugs and earning rewards!
* **2018.10.11**: Join our Bug Bounty Program and earn rewards now!

### How to report a bug

#### Determining scope
[Bitmarkd](https://github.com/bitmark-inc/bitmarkd) is the codebase for the Bitmark blockchain.

##### Bug scope
Only bugs in Scope are eligible for a bug bounty. A qualifying bug has to be a danger to the blockchain records, privacy, or client operations. These include bugs in:
1. **Protocol**: Flaws in protocol design, an example being the incentive design flaw in the [white paper](https://bitmark.com/assets/bitmark_technical-white-paper.pdf)
2. **Implementation of client**: Any implementation bug in `bitmarkd` that could cause cause bad block, invalid assets, transaction failure, bad operations, or program crashes
3. **Cryptography**: Incorrect implementation of Cryptographic algorithms
4. **Network Attacks**: Attacks such as Sybil attacks
5. Any bugs that Bitmark considers important

##### Restrict online low-bandwidth attack to these two nodes only:
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

### Disclosure policy
Please discuss with us before disclosure of your bugs. Bitmark will endeavor to respond to reports within **2-3 business days** and will make every effort to quickly address reported vulnerabilities. To encourage responsible reporting, we commit that we will **not take legal action** against you or ask law enforcement to investigate you if you give us at least **90 days** from the time of your report to correct the issue before you make the reported vulnerability public.

Contact us at: [security@bitmark.com](mailto:security@bitmark.com)



## Updates to this Document

Bitmark Inc. may update this document from time to time. We will maintain a [revision history](https://github.com/bitmark-inc/legal/commits/master/contribute.md) in our revision control repository.


## Questions

Questions should be directed to: [protocol@bitmark.com](mailto:protocol@bitmark.com).