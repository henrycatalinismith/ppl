const expect = require('expect.js');
const UsageError = require('../../src/errors/usage');
const add = require('../../src/commands/add');

describe('add command', () => {
  it('throws a UsageError when no contact ID is given', () => {
    expect(() => add.run([])).to.throwError(e => {
      expect(e).to.be.a(UsageError);
      expect(e.message).to.be('No contact specified')
    });
  });

  it('throws a UsageError when no name is given', () => {
    expect(() => add.run(['test'])).to.throwError(e => {
      expect(e).to.be.a(UsageError);
      expect(e.message).to.be('No name specified')
    });
  });
});
