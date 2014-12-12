# PGit

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

1. Install via RubyGems:

```
$ gem install pgit
```

2. Setup configuration file:

```
$ pgit install
```

This will generate a YAML file under `~/.pgit.rc.yml`. Edit that file to add information about projects that you're working on.  Each project needs a project `id`, Pivotal Tracker `api_token`, and `path`

