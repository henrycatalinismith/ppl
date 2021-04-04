---
command: grep
summary: Search the address book
synopsis: ppl grep <options> <search>
see_also:
  - text: git grep
    href: http://git-scm.com/docs/git-grep
---

This command is an alias of `git grep`. The `<options>` and the `<search>`
string given are passed straight on through to `git grep`.

The format and color of the output of this command is subject to your system's
git configuration, not the contents of your `~/.pplconfig`.

## Examples

    $ ppl grep smith
    john.vcf:EMAIL:john.smith@example.org

