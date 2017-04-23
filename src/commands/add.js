const Contact = require('../contact');
const UsageError = require('../errors/usage');
const { saveContact } = require('../repository');

module.exports.usage = 'ppl add <contact> <name>';

module.exports.run = argv => new Promise((resolve, reject) => {
  const [ id, name ] = argv;

  if (!id) {
    return reject(new UsageError('No contact specified'));
  }

  if (!name) {
    return reject(new UsageError('No name specified'));
  }

  const contact = Contact.create(id, name);
  return saveContact(contact);
});
