---
name: color
summary: Colorized output
example: |
  [color]
      age = true
      bday = true
      email = true
      ls = true
      name = true
      nick = true
      org = true
      phone = true
      post = true
      show = true
      url = true
---

By default, ppl's commands output plain text with no [ANSI color escape
codes](http://en.wikipedia.org/wiki/ANSI_escape_code). This is good in terms of
ppl being a well-behaved, pipeable UNIX CLI program, but some people like a bit
more color in their life, and this section of the config file allows those
people to selectively enable color output on a per-command basis. The above
example config enables colorized output for all commands.

## List of supported colors

* black
* blue
* cyan
* green
* magenta
* red
* white
* yellow

## Unsupported commands

The [mutt](/commands/mutt) command doesn't support color output and never will.
It'd be completely pointless.

The [show](/commands/show) command doesn't, either, but could one day.

