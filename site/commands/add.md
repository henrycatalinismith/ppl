---
command: add
summary: Add a new contact
synopsis: ppl add <contact> <name>
---

This command adds a new contact to the address book. The first parameter,
`<contact>`, is an alphanumeric string used to uniquely identify the contact
within the address book. The second parameter, `<name>`, is the contact's actual
name.

The `<contact>` parameter must not already be in use as the identifier of
another contact in the address book. Ideally you'll want to pick something short
and easy to type, so if you're adding a contact named "John Doe", then "john" or
"jdoe" might be good choices if they aren't already in use.

The `<name>` parameter should be the full name of the contact, and is identical
to its namesake expected by the [ppl name](../name) command.  Usually, this
means it needs to be enclosed in quotation marks to indicate that all the words
in the name are part of the same parameter. 

The first word in the `<name>` will also be stored as the contact's given name,
with the remainder of the string being treated as their family name.

## Examples

    ppl add jdoe "John Doe"

