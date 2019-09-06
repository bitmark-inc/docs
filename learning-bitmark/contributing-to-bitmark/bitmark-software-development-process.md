# Current development workflow

**Right now we have the following projects:**
* bitmarkd
* Core API
* Updaterd
* Backend services

**Development process:**

Our current workflow is based on OKR, where we define sprints as a deadline to deliver the software artefact. Also as part of this workflow, we have daily standup meetings where we can follow up the progress of each individual and its related tasks to accomplish the OKR. The OKR is defined quarterly. To track the deliverables, nowadays we are using a mix of project management with software management methodologies.

![](https://github.com/bitmark-inc/docs/blob/master/learning-bitmark/contributing-to-bitmark/imgs/project_bitmarkd.png)


**Branch, Tag and release process:**

We have a single development branch master, from where we create tags to perform minor and major releases. The development never happens directly on branch master, instead the developer create a development branch from master, after the developer believes its branch is ready, it opens a pull request and assign another developer to make a review. After the review process, the developer merges its branch to master branch and deletes the development branch. The developers never commit directly into the master branch without passing through the review process.

![](https://github.com/bitmark-inc/docs/blob/master/learning-bitmark/contributing-to-bitmark/imgs/github_branches.png)


**Review process:**

We have a peer review process, where the developer can assign one or more individuals to verify its code, these individuals shall suggest modifications or accept the pull request, also the reviewer can reassign the review. Currently there are no time outs specified for reviewers, and in such a case, if a reviewer is delaying the review, it must be discussed during the stand-up daily meeting.

![](https://github.com/bitmark-inc/docs/blob/master/learning-bitmark/contributing-to-bitmark/imgs/review-process.png)

# Development work-flow improvements

**Development process:**

This is a proposal for our working flow using GitHub. Here I describe 3 basic areas that will improve development, quality assurance and release.


![](https://github.com/bitmark-inc/docs/blob/master/learning-bitmark/contributing-to-bitmark/imgs/new-review-process.png)


**What to do when there is a new patch?**

First, we need to ask ourselves, is it a trivial patch? In case it is not a 3-lines change patch, it means, it is not a trivial patch, sometimes even a 3-lines change is not trivial. We do need to be mature enough to understand what is and what is not a trivial patch. In case it is not a trivial patch, we should open a GitHub issue with a proper title and describe what is the problem we are trying to fix, following with a pull request with a patch (if we have one), this patch must point out to the issue number. All the discussion related to implementation, shall be done in the issue, code problems shall be done in the pull request.

**I would like to stress a bit how to perform a proper code review:**

We need to always remember, there are other people watching us, the information is on the Internet and it will always be there, we need developers to engage with us, perhaps we need companies out there to see us relevant and join our cause.

**What to do:**

1. Know what you are reviewing, understand what the developer is trying to achieve.
2. Know what to look for in code: Structure, Style, Logic, Performance, Test coverage, Design, Readability, Maintainability and Functionality. (although some of these items should have been discussed prior to open an issue or pull request)
3. Does it pass on CircleCi/TravisCi and Jenkins? Otherwise don't need start to make a review.
4. Build and test.
5. Give feedback that helps and not hurt, be impartial, as much as you prefer BLUE, some other people prefer YELLOW, so be impartial.
6. Communicate goals and expectations, we use Slack and if we have direct access to the person that opened the code review, instead to go and make a comment and wait the person reply, talk directly with the person, it saves time and foster a positive culture.
7. Peer review is all about trust, we need to be glad somebody is asking us to review its code.
8. Be nice, at the end of the day, there is no software made by only one person.
9. If the pull request comes from an outsider contributor, be nicer than usual, even if you need to fix his code before merge and give all the credits to him/her, we need this person to come back and start to contribute more often. So, don't be harsh with newcomers.
10. Remember, when you are doing a code review it might take 30 minutes of your time, but the person that made the code might have spent weeks, so be empathetic.

**What not to do:**

1. Broken English, most of us are not native speakers, there is no problem to use Google translation to help us when we want to write something, especially when it is public.
2. Be specific and with short sentences, go direct to the point, forget about philosophy and what you read yesterday in that nice agile article.
3. Nobody really cares if you prefer "for" or "while", so don't nit-picking other people's code,  it is demotivating.
4. Don't do unsolicited code review, if the peer didn't add you in the code review, there is a reason for that.
5. No power struggling in public, you won't become "millionaire" bashing your peers.
6. Don't write huge messages, if you can't explain it with short sentences, go to slack, send an email or make a phone call in case your peer works at Bitmark Inc..
7. Don't be too verbose and pedantic.

**Before opening a pull request:**

Make sure you have everything in place, when you open a pull request it means your code is ready for review. Here are some steps before you open a pull request.
1. Have you discussed this patch with your peers prior start coding?
2. How critical is the impact of these changes?
3. Did you open a GitHub issue explaining what this code is about?
4. Is it a new feature? Do we have a software design document with the result of all discussion? (prior to code or prototype)
5. Did you run golint, misspell, go test and go build?
6. Did you test if the code really does what it's supposed to?
7. Is your code following the Golang specification? https://golang.org/ref/spec
8. Will your peers know how to test and validate it?
9. Did you cover it with unit tests?
10. Are your commit messages clear and concise?
11. Do you need documentation or update one?
12. Do you need QA?
13. When this fix/feature needs to be released?
14. Do we need extra validation like run on TestNet for awhile?

**Quality assurance:**

The quality assurance team must focus on the number of issues that were closed and must be included in the next RELEASE, they also have the power to control what can and cannot be included in the next RELEASE, they shall be in charge to stabilize the software and make sure the documentation is updated according. They should also be included in the preparation of the RELEASE notes.

To make the software stable, we need to stabilize a branch and let the Developers test it and give time for QA to validate it prior to RELEASE it, also we need to enforce a freeze time where the branch won't receive any critical change or new feature, and it will be focused only in stabilize the version.

![](https://github.com/bitmark-inc/docs/blob/master/learning-bitmark/contributing-to-bitmark/imgs/freeze-branch.png)

**Code freeze and QA steps:**

1. We must set a group of features or fixes as a milestone for the next RELEASE, best would be to have a ROADMAP or MoSCoW for a particular version.
2. We schedule a candidate date for the RELEASE.
3. We announce the freeze time.
4. Branch stable-version from master.
5. Freeze branch master and stable.
6. If QA find a regression, the fix must first goes into master and from there cherry-picked to stable.
7. QA should validate it first prior the PR is merged into master and stable.
8. Release the software.
9. Unfreeze branch master.

**Release process:**

The release process is a critical path that ensures we will accomplish the stakeholders requirements and deliver the intended objectives. Also it establishes a routine of communication internally and external, stakeholders, developers and users have a standard to follow and knows what to expect from the project.


![](https://github.com/bitmark-inc/docs/blob/master/learning-bitmark/contributing-to-bitmark/imgs/release-process.png)

**Release steps:**

1. Planning the release, what features should be in this version, what bug fixes if we know beforehand, documentation update, users communication and so on.
2. Initial feature specification in a high level description, more detailed and technical specification (issue), code, PR and merge.
3. Build a release candidate and eat our own dog food.
4. QA verification trying to automate as much as possible any test.
5. QA tests, all GREEN, QA gives Acceptance, CTO pushes the GO button.
6. Build the official release and release notes.
7. QA and team validation.
8. Release rolled out.
9. Public communication.
10. Bitmark Inc. internal release validation (mimic an end user).
