---
title: Bitmark Software Development Process
keywords: development process, work flow
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/contributing-to-bitmark/bitmark-software-development-process
folder: learning-bitmark/contributing-to-bitmark
---

# Current development workflow

**Right now we have these projects:**
* bitmarkd
* Core API
* Updaterd
* Backend services
* Bitmark SDK

**Development process:**

Our current workflow uses OKR, where we define sprints as a deadline to deliver the software artefact, but we do not limit ourselves. We do translate the OKR in ISSUES on GitHub where we can track them. The external contributors can get involved with the project opening new ISSUES, being part of the discussion in existent ISSUES and make PULL REQUESTS within our projects.

![](/assets/images/project_bitmarkd.png)


**Branch, Tag and release process:**

We have a single development branch master, from where we create tags to perform minor and major releases. The development never happens directly on branch master, instead the developer create a development branch from master, after the developer believes its branch is ready, it opens a pull request and assign another developer to make a review. After the review process, the developer merges its branch to master branch and deletes the development branch. The developers never commit directly into the master branch without passing through the review process.

![](/assets/images/github_branches.png)


**Review process:**

We have a peer review process, where the developer can assign one or more individuals to verify its code, these individuals shall suggest modifications or accept the pull request, also the reviewer can reassign the review. Currently there are no time outs specified for reviewers, and in such a case, if a reviewer is delaying the review, it must discuss during the stand-up daily meeting.

![](/assets/images/review-process.png)

# Development work-flow improvements

**Development process:**

This is our working flow using GitHub. Here I describe 3 basic areas of our development process.


![](/assets/images/new-review-process.png)


**What to do when there is a new patch?**

First, we need to ask ourselves, is it a trivial patch? In case it is not a 3-lines change patch, it means, it is not a trivial patch, sometimes even a 3-lines change is not trivial. We do need to be mature enough to understand what is and what is not a trivial patch. In case it is not a trivial patch, we shall open a GitHub issue with a proper title and describe what is the problem we are trying to fix, following with a pull request with a patch (if we have one), this patch must point out to the issue number. All the discussion related to implementation, shall be in the issue, code problems shall be in the pull request.

**I would like to stress a bit how to perform a proper code review:**

We need to always remember, there are other people watching us, the information is on the Internet and it will always be there, we need developers to engage with us, perhaps we need companies out there to see us relevant and join our cause.

**What to do:**

1. Know what is under review, understand what the developer is trying to achieve.
2. Know what to look for in code: Structure, Style, Logic, Performance, Test coverage, Design, Readability, Maintainability and Functionality.
3. Does it pass on CircleCI/TravisCI and Jenkins? Otherwise don't need start to make a review.
4. Build and test.
5. Give feedback that helps and not hurt, be impartial, as much as somebody prefers BLUE, some other people prefer YELLOW, so be impartial.
6. Communicate goals and expectations, we use Slack and if we have direct access to the person that opened the code review, instead to go and make a comment and wait the person reply, talk directly with the person, it saves time and foster a positive culture.
7. Peer review is all about trust, we need to be glad somebody is asking us to review its code.
8. Be nice, at the end of the day, there is no software made by only one person.
9. If the pull request comes from an outsider contributor, be nicer than usual, even if it is necessary to fix any code before merge and give all the credits to him/her, we need this person to come back and start to contribute more often. So, don't be harsh with newcomers.
10. Remember, when doing a code review it might takes 30 minutes, but the person that made the code might have spent weeks, so be empathetic.

**What not to do:**

1. Broken English, most of us are not native speakers, there is no problem to use Google translation to help us when we want to write something, especially when it is public.
2. Be specific and with short sentences, go direct to the point.
3. Nobody really cares if someone else prefer "for" or "while", so don't nit-picking other people's code,  it is demotivating.
4. Don't do unsolicited code review..
5. No power struggling in public, nobody will become "millionaire" bashing each other.
6. Don't write big messages, short sentences are easier to understand, go to slack, send an email or make a phone call in case the peer works at Bitmark Inc..
7. Don't be too verbose and pedantic.

**Before opening a pull request:**

Make sure everything is in place, when a pull request is open, it means the code is ready for review. Here are some steps before open a pull request.
1. Does the code needs a broad discussion with other peers?
2. How critical is the impact of these changes?
3. Is there a GitHub issue explaining what this code is about?
4. Is it a new feature? Do we have a software design document with the result of all discussion? (prior to code or prototype)
5. The tools, misspell, go test and go build, did run fine, didn't it?
6. Does the code does what it proposes?
7. Does the code follows the Golang specification? https://golang.org/ref/spec
8. Will reviewers know how to test and validate it?
9. Is there enough coverage with unit tests?
10. Does the commit history has a clear and concise message?
11. Does it needs documentation?
12. Does it needs QA?
13. Does this fix/feature needs to be part of the next release?
14. Do we need extra validation like run on Testnet for a while?

**Quality assurance:**

The quality assurance team must focus on the number of issues closed and must be part of the next RELEASE, they also have the power to control what can and cannot be part of the next RELEASE, they shall be in charge to stabilize the software and make sure the documentation is update. They also must help to prepare the RELEASE notes.

To make the software stable, we need to stabilize a branch and let the Developers test it and give time for QA to validate it prior to RELEASE it and also we need to enforce a freeze time where the branch won't receive any critical change or new feature.

![](/assets/images/freeze-branch.png)

**Code freeze and QA steps:**

1. We must set a group of features or fixes as a milestone for the next RELEASE, best would be to have a ROADMAP or MoSCoW for a particular version.
2. We schedule a candidate date for the RELEASE.
3. We announce the freeze time.
4. Branch stable-version from master.
5. Freeze branch master and stable.
6. If QA find a regression, the fix must first goes into master and from there cherry-picked to stable.
7. QA must validate it first prior the PR merges into master and stable.
8. Release the software.
9. Unfreeze branch master.

**Release process:**

The release process is a critical path that ensures we will accomplish the stakeholders requirements and deliver the intended objectives. Also it establishes a routine of communication internally and external, stakeholders, developers and users have a standard to follow and knows what to expect from the project.


![](/assets/images/release-process.png)

**Release steps:**

1. Planning the release, what features shall be in this version, what bug fixes if we know beforehand, documentation update, users communication and so on.
2. Initial feature specification in a high level description, more detailed and technical specification (issue), code, PR and merge.
3. Build a release candidate and eat our own dog food.
4. QA verification trying to automate as much as possible any test.
5. QA tests, all GREEN, QA gives Acceptance, CTO pushes the GO button.
6. Build the official release and release notes.
7. QA and team validation.
8. Release rolled out.
9. Public communication.
10. Bitmark Inc. internal release validation (mimic an end user).
