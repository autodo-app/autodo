# auToDo Contributing Guide

The auToDo source code is managed using Git and is hosted on GitHub.

```
git clone git://github.com/autodo-app/autodo
```

## Bug Reports and Feature Requests

If you have encountered a problem with auToDo or have an idea for a new
feature, please submit it to the [issue tracker](https://github.com/autodo-app/autodo/issues) on Github.

If possible, for bug reports please include the debug console output containing the error you experienced. The more information you can provide about the error, the better.

## Contributing to auToDo

The recommended way for new contributors to submit code to auToDo is to fork
the repository on GitHub and then submit a pull request after
committing the changes.  The pull request will then need to be approved by one
of the core developers before it is merged into the main repository.

- Check for open issues or open a fresh issue to start a discussion around a feature idea or a bug.
- Fork the repository on GitHub to start making your changes to the `master` branch.
- Write a test plan which shows that the bug was fixed or that the feature works as expected. This can either be a series of steps to execute on a device running the auToDo app or test code to run.

**TODO: move to a gitflow setup to improve structure** 

## Getting Started

These are the basic steps needed to start developing for auToDo.

- Create an account on GitHub.
- Fork the main auToDo repository ([autodo-app/autodo](https://github.com/autodo-app/autodo)) using the GitHub interface.
- Clone the forked repository to your machine.

```
git clone https://github.com/USERNAME/autodo
cd autodo
```

- Checkout the appropriate branch. **TODO: update this for git flow**
- Create a new working branch.  Choose any name you like.

```
git checkout -b feature-xyz
```

- Push changes in the branch to your forked repository on GitHub.

```
git push origin feature-xyz
```

- Submit a pull request from your branch to the respective branch (`master` or `X.Y`)
- Wait for a core developer to review your changes.


## Core Developers

The core developers of auToDo have write access to the main repository.  They can commit changes, accept/reject pull requests, and manage items on the issue tracker.

You do not need to be a core developer or have write access to be involved in the development of auToDo.  You can create pull requests from forked repositories and have a core developer add the changes for you.

Coding Guide
------------

- Try to use the same code style as used in the rest of the project. **TODO: define a styleguide**
- New features should be documented.  Include examples and use cases where appropriate.
- Add appropriate unit tests. **TODO: this isn't really a thing yet**

## Branch Model

**TODO: git flow link/explanation here**

## Unit Testing

**TODO: more info will come on this when unit testing gets set up**