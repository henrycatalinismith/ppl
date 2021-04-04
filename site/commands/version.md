---
name: version
summary: Display ppl's version number
synopsis: ppl version
---

This command simply displays the current version of ppl installed on the system.

Pre-1.9.0 versions of ppl lack this command, but `gem list --local | grep ppl`
ought to do the job just fine in its absence anyway.

## Examples

    $ ppl version
    ppl version 1.9.0

