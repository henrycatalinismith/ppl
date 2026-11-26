---
title: ppl init Manual Page
layout: command
section: documentation
command: init
---

### Name

ppl init - Create an empty address book

### Synopsis

    ppl init [<directory>]

### Description

This command creates an empty ppl repository. It creates the specified directory
if it doesn't already exist, and initializes a git repository there.

If no `<directory>` parameter is explicitly specified, then the operation is
applied to the current working directory.

If no default address book has been configured yet, the new address book
becomes the default by adding an `[address book]` section to `~/.pplconfig`.
This lets ppl keep working with it even after you `cd` into another directory.
An existing default is left unchanged.

### Examples

    ppl init ~/contacts


