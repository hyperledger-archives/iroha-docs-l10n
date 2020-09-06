First off, thanks for taking the time to contribute!

The following is a short set of guidelines for contributing to Iroha.


#### Table Of Contents

##### [How Can I Contribute?](#how-can-i-contribute-1)

- [Reporting Bugs](#reporting-bugs)
- [Reporting Vulnerabilities](#reporting-vulnerabilities)
- [Suggesting Improvements](#suggesting-improvements)
- [Asking Questions](#asking-questions)
- [Your First Code Contribution](#your-first-code-contribution)
- [Pull Requests](#pull-requests)

##### [Styleguides](#styleguides-1)

- [Git Style Guide](#git-style-guide)
- [C++ Style Guide](#c-style-guide)
- [Documentation Styleguide](#documentation-styleguide)

### [Contact Developers](#places-where-community-is-active)


## How Can I Contribute?

### Reporting Bugs

*Bug* is an error, design flaw, failure or fault in Iroha that causes it to produce an incorrect or unexpected result, or to behave in unintended ways.

Bugs are tracked as [JIRA issues](https://jira.hyperledger.org/projects/IR/issues/IR-275?filter=allopenissues&orderby=issuetype+ASC%2C+priority+DESC%2C+updated+DESC) in Hyperledger Jira.

To submit a bug, [create new issue](https://jira.hyperledger.org/secure/CreateIssue.jspa) and include these details:

| Field                   | What to enter                                                    |
| :---------------------- | ---------------------------------------------------------------- |
| Project                 | Iroha (IR)                                                       |
| Issue Type              | Bug                                                              |
| Summary                 | Essence of the problem                                               |
| Description             | What the issue is about; if you have any logs, please provide them|
| Priority                | You can use Medium though if you see the issue as a high priority, please choose that|
| Environment             | Your OS, device's specs, Virtual Environment if you use one, version of Iroha etc. |


### Reporting Vulnerabilities

While we try to be proactive in preventing security problems, we do not assume they’ll never come up.

It is standard practice to responsibly and privately disclose to the vendor (Hyperledger organization)
a security problem before publicizing, so a fix can be prepared, and damage from the vulnerability minimized.

Before the First Major Release (1.0) all vulnerabilities are considered to be bugs, so feel free to submit them as described above.
After the First Major Release please utilize [a bug bounty program here](https://hackerone.com/hyperledger) in order to submit vulnerabilities and get your reward.

In any case — feel free to reach to any of existing maintainers in Rocket.Chat private messages or in an e-mail (check CONTRIBUTORS.md file) if you want to discuss whether your discovery is a vulnerability or a bug.

### Suggesting Improvements

An *improvement* is a code or idea, which makes **existing** code or design faster, more stable, portable, secure or better in any other way.

Improvements are tracked as [JIRA improvements](https://jira.hyperledger.org/browse/IR-184?jql=project%20%3D%20IR%20and%20issuetype%20%3D%20Improvement%20ORDER%20BY%20updated%20DESC). To submit new improvement, [create new issue](https://jira.hyperledger.org/secure/CreateIssue.jspa) and include these details:

| Field                   | What to enter                                                    |
| :---------------------- | ---------------------------------------------------------------- |
| Project                 | Iroha (IR)                                                       |
| Issue Type              | Improvement                                                      |
| Summary                 | Essence of the idea                                              |
| Description             | What the idea is about; if you have any code suggestions, you are welcome to add them here |
| Priority                | You can use Medium                                               |
| Assign                  | You can assign the task to yourself if you are planning on working on it|

### Asking Questions

A *question* is any discussion that is typically neigher a bug, nor feature request or improvement. If you have a question like "How do I do X?" - this paragraph is for you.

Please post your question in [your favourite messenger](#places-where-community-is-active) so members of the community could help you. You can also help others!

### Your First Code Contribution

Read our [C++ Style Guide](#c-style-guide) and start with beginner-friendly issues with JIRA label [`[good-first-issue]`](https://jira.hyperledger.org/issues/?jql=project%20%3D%20IR%20and%20labels%20%3D%20good-first-issue%20ORDER%20BY%20updated%20DESC) <- click here. Indicate somehow that you are working on this task: get in touch with maintainers team, community or simply assign this issue to yourself.

### Pull Requests

- Fill in [the required template](.github/PULL_REQUEST_TEMPLATE.md)

- End all files with a newline

- **Write tests** for new code. Test coverage for new code must be at least 70%

- Every pull request should be reviewed and **get at least two approvals from maintainers team**. Check who is a current maintainer in [MAINTAINERS.md](https://github.com/hyperledger/iroha/blob/master/MAINTAINERS.md) file

- When you've finished work make sure that you've got all passing CI checks — after that **squash and merge** your pull request

- Follow the [C++ Style Guide](#c-style-guide)

- Follow the [Git Style Guide](#git-style-guide)

- **Document new code** based on the [Documentation Styleguide](#documentation-styleguide)

- When working with **PRs from forks** check [this manual](https://help.github.com/articles/checking-out-pull-requests-locally)


## Styleguides

### Git Style Guide

- **Sign-off every commit** with [DCO](https://github.com/apps/dco): `Signed-off-by: $NAME <$EMAIL>`. You can do it automatically using `git commit -s`
- **Use present tense** ("Add feature", not "Added feature").
- **Use imperative mood** ("Deploy docker to..." not "Deploys docker to...").
- Write meaningful commit message.
- Limit the first line of commit message to 50 characters or less
- First line of commit message must contain summary of work done, second line must contain empty line, third and other lines can contain list of commit changes


### C++ Style Guide

- Use clang-format [settings](https://github.com/hyperledger/iroha/blob/master/.clang-format) file. There are guides available on the internet (e.g. [Kratos wiki](https://github.com/KratosMultiphysics/Kratos/wiki/How-to-configure-clang%E2%80%90format))
- Follow [CppCoreGuidelines](http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines) and [Cpp Best Practices](https://lefticus.gitbooks.io/cpp-best-practices).
- Avoid [platform-dependent](https://stackoverflow.com/questions/1558194/learning-and-cross-platform-development-c) code.
- Use [C++14](https://en.wikipedia.org/wiki/C%2B%2B14).
- Use [camelCase](https://en.wikipedia.org/wiki/Camel_case) for class names and methods, use [snake_case](https://en.wikipedia.org/wiki/Snake_case) for variables.



### Documentation Styleguide

- Use [Doxygen](http://www.stack.nl/~dimitri/doxygen/manual/docblocks.html).
- Document all public API: methods, functions, members, templates, classes...


### Places where community is active

Our community members are active at:

| Service      | Link                                                         |
| ------------ | ------------------------------------------------------------ |
| RocketChat   | https://chat.hyperledger.org/channel/iroha                   |
| StackOverflow| https://stackoverflow.com/questions/tagged/hyperledger-iroha |
| Mailing List | [hyperledger-iroha@lists.hyperledger.org](mailto:hyperledger-iroha@lists.hyperledger.org)                              |
| Gitter       | https://gitter.im/hyperledger-iroha/Lobby                    |
| Telegram     | https://t.me/hl_iroha                                        |
| YouTube      | https://www.youtube.com/channel/UCYlK9OrZo9hvNYFuf0vrwww     |



---

Thank you for reading the document! 
