---
title: Colorized Output Released
date: 2013-03-16
---

It's been about a month since the last release, but that's not because of any
lack of internal activity. Today marks the release of support for git-style
colorized output, configurable in `~/.pplconfig`.

This has taken a while to achieve just because I wanted to take my time over it
and try to really get it right the first time. Some refactoring was necessary in
order to get config data into the code responsible for formatting output, but
hopefully the resulting usage of the
[morphine](https://github.com/bkeepers/morphine) dependency injection container
should reduce such code churn in future.

In other news, the [UTF-8 bug](https://github.com/hendotcat/ppl/issues/17) mentioned
in [last month's update](/news/two-months-in/) should be gone soon. I've spoken
to the maintainer of vpim about it, and [his
response](http://rubyforge.org/pipermail/vpim-talk/2013/000185.html) was
positive. Apparently vpim just doesn't quite support Ruby 1.9.1's String class
yet, but will do soon.


