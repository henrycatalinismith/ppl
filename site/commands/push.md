---
command: push
summary: Execute `git push` in the address book directory
synopsis: ppl push <remote> <branch>
see_also:
  - text: git pull
    href: http://git-scm.com/docs/git-pull
  - text: ppl pull
    href: /commands/pull
  - text: ppl remote
    href: /commands/remote
---

This command is an alias of `git push`. It is intended to make it more
convenient to use git to synchronise your address book. See the documentation
for [git pull](/documentation/commands/pull) for more details.

Note that this command literally executes the git command `push` in the address
book directory. If you don't have the git CLI tool installed, this command will
not work.

## Examples

    $ ppl push origin main
    Everything up-to-date.

