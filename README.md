# ticket-app-syncer

This action allow replication of required files in ticket app, so each application is in sync and have correct version.

## Usage

The following is a basic example of a Github Actions workflow:

```yml
on: [push]

jobs:
  sync-repos:
    runs-on: ubuntu-latest
    name: Sync updates to repositories
    steps:
      - name: My Sync Name
        uses: Flex4Business/ticket-app-syncer@main
        with:
          source_repo: git@github.com:[SOURCE_REPO]
          destination_repo: git@github.com:[DEST_REPO]
          private_ssh_key: ${{ secrets.SSH_PRIVATE_KEY }}
```

Repeat the step for each app you wish to sync basic project files for.

* Note: you need to put a valid private SSH key into repo secret store.
