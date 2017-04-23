const UsageError = require('../errors/usage');

module.exports.usage = 'ppl add <contact> <name>';

module.exports.run = argv => {
  const [ contact, name ] = argv;

  if (!contact) {
    throw new UsageError('No contact specified');
  }

  if (!name) {
    throw new UsageError('No name specified');
  }

};
