---
name: pull
summary: Execute `git pull` in the address book directory
synopsis: ppl pull <remote> <branch>
see_also:
  - text: git pull
    href: http://git-scm.com/docs/git-pull
  - text: ppl push
    href: /commands/push
  - text: ppl remote
    href: /commands/remote
---

This command is an alias of `git pull`. It is intended to make it more
convenient to use git to synchronise your address book. The rationale is that it
is tiresome to have to type `cd ~/contacts` and then `git pull origin main`.
Assuming you have configured ppl to [remember the location of your address
book](/settings/address-book), then `ppl pull origin main`
is the equivalent of those two commands.

Note that this command literally executes the git command `push` in the address
book directory. If you don't have the git CLI tool installed, this command will
not work.

## Examples

    $ ppl pull origin main
    Already up-to-date.

