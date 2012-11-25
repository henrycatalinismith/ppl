     _____  _____  __
    |  _  ||  _  ||  |
    |   __||   __||  |__
    |__|   |__|   |_____|


ppl aims to be address book software for command-line users. It's pronounced
like "people". You might be interested in ppl if:

* You like using the command-line
* You want ownership of your address book data back from the cloud
* You prefer to keep your data stored in an open format

ppl is in an incomplete state right now, and is in active development. Stay
tuned.

[![Build Status](https://secure.travis-ci.org/h2s/ppl.png)](http://travis-ci.org/h2s/ppl)

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
$ ppl birthday john 1980-01-01
```

Roadmap
-------

One of the core ideas of ppl is for it to turn your address book into a Git
repository. In an earlier version, this was achieved using
[Rugged](https://github.com/libgit2/rugged). This functionality will be added
back in so that contact information can be easily synced between computers. In
the meantime, ppl simply writes to disk.

Other data about contacts will also be supported, such as:
* Postal addresses
* Phone numbers
* The name of the organization to which the contact belongs
* The position of the contact within their organization

The email address handling is currently very rudimentary. The eventual plan is
to support storage of several addresses per contact. Addresses will be able to
be organized according to location, such as "home" or "work", and it will be
possible to mark a particular address as "preferred" for each location.

Here's a quick mockup of the sort of output `ppl show` should produce a little
further down the road once some of these goals have been reached:

    Fred Smith <fred.smith@example.org>

    -- Email Addresses -------------------------------------------------------------

       Home
     * fred.smith@example.org
       fsmith@aol.com

       Work
     * fred.smith@megacorp.com
       fred.s.123@initrode.net

    -- Postal Addresses ------------------------------------------------------------

       Home
       1 Testing Road, TestVille, Testing, CA, 12345

       Work
       30 Business Road, TestVille, Testing, CA, 23454

    -- Telephone Numbers -----------------------------------------------------------

       01234567891
       09876541233

Contributing
------------

Bug reports, fixes, and additional features are encouraged. The project uses
[Github issues](https://github.com/h2s/ppl/issues) to track bug reports.

If you'd like to contribute code, please just bear in mind that ppl development
is test-driven and attempts to follow the "Object Mentor school of clean code"
as described in the book [Clean
Code](http://books.google.co.uk/books?id=_i6bDeoCQzsC).

License
-------

ppl is licensed under the GNU GENERAL PUBLIC LICENSE Version 2.

