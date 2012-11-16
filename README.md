     _____  _____  __
    |  _  ||  _  ||  |
    |   __||   __||  |__
    |__|   |__|   |_____|


ppl aims to be address book software for command-line users. It's pronounced
like "people". You might be interested in ppl if:

* You like using the command-line
* You want ownership of your address book data back from the cloud
* You prefer to keep your data stored in an open format

ppl makes your address book into a Git repository. Changes to your address book
are commits. The plan is to use remotes, pushing and pulling to handle address
book syncing.

Usage
-----

### Add a contact

```bash
$ ppl contact:add adam "Adam Brown"
```

### Update a contact

```bash
$ ppl set:email adam adam.brown@example.com
```

### List all contacts

```bash
$ ppl contact:list
fred:   Fred Smith <fred.smith@example.org>
dave:   Dave Jones <dave.jones@example.org>
joe:    Joe Bloggs <joe.bloggs@example.org>
```

### Show a single contact

```bash
$ ppl contact:show fred
Fred Smith
fred.simth@example.org
    
Birthday      1980-01-01
Cellphone     01189998819991197253
````

### Delete a contact

```bash
$ ppl contact:rm workadam
```

### Rename a contact

```bash
$ ppl contact:mv adam workadam
```

Configuration
-------------

ppl is configured using `~/.pplconfig`. This is intended to be familiar to Git
users, and thus the file has similar syntax to `.gitconfig`. Here's a quick,
simple example of the kind of configuration that's supported.

```ini
[address_book]
path = "~/ppl"

[alias]
ls = contact:ls
mv = contact:mv

[color]
contact:list = true

[color "contact list"]
email = red
```





