---
name: completion
summary: Output a completion function for shell integration
synopsis: ppl completion <shell>
see_also:
  - text: Bash Integration Guide
    href: /integrations/bash
  - text: ZSH Integration Guide
    href: /integrations/zsh
---

Output a shell autocomplete function to enable automatic completion of commands

The following shells are supported:

* `bash`
* `zsh`

## Examples

    $ ppl completion bash
    _ppl()
    {
      ....
    }
    complete -F _ppl ppl

