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
$ ppl add adam "Adam Brown"
```

### Update a contact

```bash
$ ppl set adam --email=adam.brown@example.com
```

### List all contacts

```bash
$ ppl ls
fred       Fred Smith   fred.smith@example.org
dave       Dave Jones   dave.jones@example.org
joe        Joe Bloggs   joe.bloggs@example.org
```

### Show a single contact

```bash
$ ppl show fred
Fred Smith
fred.simth@example.org
    
Birthday      1980-01-01
Cellphone     01189998819991197253
````

### List upcoming birthdays

```bash
$ ppl birthdays
fred      Fred Smith 1980-01-01  99 days
dave      Dave Jones 1980-01-02  100 days
joe       Joe Bloggs 1980-01-03  101 days
```

### Delete a contact

```bash
$ ppl rm workadam
```

Configuration
-------------

ppl is configured using `~/.pplconfig`. This is intended to be familiar to Git
users, and thus the file has similar syntax to `.gitconfig`.

```ini
[address_book]
path = "~/ppl"
```

Roadmap
-------

Support for the following commands is planned.

### Rename a contact

```bash
$ ppl mv adam workadam
```

### Sync contacts using Git

```bash
$ ppl sync
Pulling latest changes from all remotes...
Pushing local changes to all remotes...
Done
```

