---
command: age
summary: List or show contacts' ages
synopsis: ppl age [<contact>]
see_also:
  - text: ppl bday
    href: /commands/bday
  - text: color output
    href: /configuration/color_age
---

This command calculates contacts' current ages in years based on their date of
birth. The purpose of this command is to provide easy access to an often-needed
piece of information which is indirectly available from the data in the address
book.

Invoked without any arguments, all contacts are listed with their respective
ages. If a `<contact>` is specified, only the age of that contact will be shown.

## Examples

    $ ppl bday jdoe 1980-01-01
    $ ppl age jdoe
    33
    $ ppl age
    fred: 25
    jdoe: 33

