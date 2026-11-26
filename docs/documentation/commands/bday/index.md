---
title: ppl bday Manual Page
layout: command
section: documentation
command: bday
---

### Name

ppl bday - List, show or change birthdays

### Synopsis

    ppl bday
    ppl bday <contact>
    ppl bday <contact> <date>

### Description

With no arguments, the dates of birth of each contact in the address book are
listed.

If a `<contact>` is specified, the date of birth of that contact is shown.

If both a `<contact>` and a `<date>` are given, then the date is stored as the
date of birth of that contact. The `<date>` parameter can be written in
any of these formats:

* `1980-02-03`, `1980/2/3`, `1980.02.03` or `19800203`
* `3/2/1980`, `3-2-1980` or `03.02.1980` (day first)
* `80-02-03` (two-digit year)
* `3 Feb 1980`, `Feb 3 1980`, `February 3, 1980` or `3rd February 1980`
* `2 March` (the current year is assumed)
* `Feb 1980` (the first of the month is assumed)

Month and weekday names may be abbreviated to three or more letters.

### Examples

    $ ppl bday jdoe 1970-01-01
    $ ppl bday adam 1975-06-01
    $ ppl bday jdoe
    1970-01-01
    $ ppl bday
    adam:  1975-06-01
    jdoe:  1970-01-01

### See Also

* [color output](/documentation/configuration/color_bday)
