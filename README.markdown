# PGit

![Travis CI Build](https://travis-ci.org/Edderic/pgit.svg?branch=master)
[![Gem Version](https://badge.fury.io/rb/pgit.svg)](http://badge.fury.io/rb/pgit)
[![Code Climate](https://codeclimate.com/github/Edderic/pgit/badges/gpa.svg)](https://codeclimate.com/github/Edderic/pgit)
[![Coverage Status](https://coveralls.io/repos/Edderic/pgit/badge.png?branch=master)](https://coveralls.io/r/Edderic/pgit?branch=master)

## Example Usage

Assuming that:
  - you have a project that uses Pivotal Tracker and Git that is listed under ~/.pgit.rc.yml
  - your working directory is in that project,
  - you want to automatically branch out based on the story title
  - the story title with story id 10102004 is "Implement a really cool feature"

```
$ pgit story_branch -s 10102004
```

will create a branch for you named `implement-really-cool-feature-10102004`

## Installation

### Install via RubyGems:

```
$ gem install pgit
```

### Create autocompletion script and configuration file
```
$ pgit install
```

### Add a project

The following will ask you questions as to which Pivotal Tracker project to associate to your working directory:

```
$ pgit proj add
```

### Create a branch

Once your working directory is associated to a Pivotal Tracker project,
this will ask you which branch to create:

```
$ pgit branch
```

### Add a command for deployment

Do you want to automate the merging/rebasing process?
`STORY_BRANCH` is the memoized current branch.

```
pgit cmd add --name="finish" --steps="git fetch origin master, git rebase origin/master, git checkout master, git merge STORY_BRANCH, git branch -d STORY_BRANCH, git push origin :STORY_BRANCH, git push origin master"
```

You can run the steps of the command as follows:

```
$ pgit cmd run finish
```


## Development

See https://www.pivotaltracker.com/n/projects/1228944 for information.
