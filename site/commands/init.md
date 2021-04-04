---
name: init
summary: Create an empty address book
synopsis: ppl init [<directory>]
---

This command creates an empty ppl repository. It creates the specified directory
if it doesn't already exist, and initializes a git repository there.

If no `<directory>` parameter is explicitly specified, then the operation is
applied to the current working directory.

## Examples

    ppl init ~/contacts


