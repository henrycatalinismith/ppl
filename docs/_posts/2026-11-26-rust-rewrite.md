---
title: Rust Rewrite
date: 2026-11-26
layout: news
section: news
categories: [news]
---

ppl has been rewritten in Rust and released as
[version 5.0.0](/development/changelog/5.0.0.html). From the outside, very
little has changed. The commands, their output and the vCard address book
format all work the same way as before, so existing address books and scripts
should keep working without any changes.

What has changed is how ppl is installed. It's now published on crates.io as
`ppl-cli`, but the command is still called `ppl`:

    $ cargo install ppl-cli

The Ruby gem is no longer maintained. If you installed it previously, remove
it with `gem uninstall ppl` before installing the new version.

## Why bother?

ppl has spent most of its life in [sleep mode](/news/sleep-mode.html) but I've
been daydreaming about a Rust rewrite for years. The performance has always
bothered me but not enough to warrant the amount of work the rewrite would
entail. All of a sudden months of work have become a morning's work and so here
we are.

## Benchmarks

Most of the time ppl spent on each command went into starting up Ruby and
loading gems before any address book work happened. Running it as a compiled
Rust binary skips a lot of waiting around for that kind of stuff.

Here's a benchmark showing the new Rust version versus the old Ruby version on
my computer using an identical address book and identical operations.

| | Ruby | Rust | Speedup |
|---|---|---|---|
| Read (`ppl show bob`) | 177 ms | 16 ms | ~11× |
| Write (`ppl email bob bob@example.org`) | 177 ms | 19 ms | ~9× |
| Cucumber test suite (41 scenarios) | 26.3 s | 2.6 s | ~10× |

Read and write times are averages over 30 runs, and test suite times are
averages over 3 runs. Every command now finishes in under 20 milliseconds,
which makes ppl feel instant.

