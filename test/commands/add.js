const expect = require('expect.js');
const sinon = require('sinon');
const UsageError = require('../../src/errors/usage');
const repository = require('../../src/repository');
const add = require('../../src/commands/add');

describe('add command', () => {
  it('throws a UsageError when no contact ID is given', done => {
    add.run([]).catch(e => {
      expect(e).to.be.a(UsageError);
      expect(e.message).to.be('No contact specified')
      done();
    });
  });

  it('throws a UsageError when no name is given', done => {
    add.run(['test']).catch(e => {
      expect(e).to.be.a(UsageError);
      expect(e.message).to.be('No name specified')
      done();
    });
  });

  it('saves the new contact to the repository', () => {
    sinon.stub(repository, 'saveContact').returns(Promise.resolve());
    add.run(['john', 'John Doe']).then(() => {
      add.run(['john', 'John Doe']);
      expect(repository.saveContact.called).to.be(true);
      repository.saveContact.restore();
    });
  });
});
