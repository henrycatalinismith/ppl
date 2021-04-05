---
name: ZSH
summary: ZSH completion setup
---

Similarly to the [Bash completion](/integrations/bash/)
functionality also available, ppl comes ready with a ZSH completion function as
well. Here's how to get it set up:

## Install the completion function

    $ ppl completion zsh | sudo tee /usr/share/zsh/site-functions/_ppl

Depending on your choice of operating system, the target directory in the above
code may differ. The above is certainly correct for Arch Linux, but on Debian,
for example, the target would be `/usr/local/share/zsh/site-functions/`.

