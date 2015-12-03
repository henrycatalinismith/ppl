     _____  _____  __
    |  _  ||  _  ||  |
    |   __||   __||  |__
    |__|   |__|   |_____|


[ppl](http://ppladdressbook.org) aims to be address book software for
command-line users. It's pronounced like "people". You might be interested in
ppl if:

* You like using the command-line
* You want ownership of your address book data back from the cloud
* You prefer to keep your data stored in an open format

[![Build Status](https://secure.travis-ci.org/hnrysmth/ppl.png)](http://travis-ci.org/hnrysmth/ppl)
[![Code Climate](https://codeclimate.com/github/hnrysmth/ppl.png)](https://codeclimate.com/github/hnrysmth/ppl)
[![Coverage Status](https://coveralls.io/repos/hnrysmth/ppl/badge.png?branch=master)](https://coveralls.io/r/hnrysmth/ppl?branch=master)

Installation
------------

```bash
$ sudo gem install ppl
```

Usage
-----

### List all contacts

```bash
$ ppl ls
dave: dave@example.org
fred: fred@example.org
john: john@example.org
```

### Add a contact
```bash
$ ppl add paul "Paul Baker"
```

### Show a contact
```bash
$ ppl show fred
Fred Smith
fred@example.org
```

### Delete a contact
```bash
$ ppl rm dave
```

### Change a contact's ID
```bash
$ ppl mv dave david
```

### Change a contact's name
```bash
$ ppl name john "John Smith"
```

### Change a contact's email address
```bash
$ ppl email dave david@example.org
```

### Change a contact's birthday
```bash
$ ppl bday john 1980-01-01
```

Contributing
------------

Bug reports, fixes, and additional features are encouraged. The project uses
[Github issues](https://github.com/hnrysmth/ppl/issues) to track bug reports.

Everyone interacting in ppl’s codebases, issue trackers etc is expected to follow the [code of conduct](https://github.com/ppladdressbook/ppl/blob/master/CODE_OF_CONDUCT.md).

License
-------

ppl is released under the [MIT License].

[MIT License]: http://www.opensource.org/licenses/MIT
