---
command: remote
summary: Execute `git remote` in the address book directory
synopsis: |
    ppl remote [-v | --verbose]
    ppl remote rename <old> <new>
    ppl remote rm <name>
see_also:
  - text: git pull
    href: http://git-scm.com/docs/git-pull
  - text: ppl pull
    href: /commands/pull
  - text: ppl push
    href: /commands/push
---

This command is an alias of `git remote`. It is intended to make it more
convenient to use git to synchronise your address book. See the documentation
for [git pull](/documentation/commands/pull) for more details.

Note that this command literally executes the git command `remote` in the
address book directory. If you don't have the git CLI tool installed, this
command will not work.

## Examples

    $ ppl remote
    origin
    github
    $ ppl remote rm github

