const Git = require('nodegit');
const fs = require('fs');

module.exports.saveContact = contact => new Promise(resolve => {
  const repoPath = `${process.cwd()}/tmp/test`;
  const filePath = `${repoPath}/${contact.id}.vcf`;

  return Git.Repository.open(repoPath).then(repository => {
    const author = Git.Signature.create(
      'Test',
      'test@example.org',
      Date.now(),
      (new Date).getTimezoneOffset()
    );

    fs.writeFileSync(filePath, contact.card.toString(), 'utf-8');

    return repository.createCommitOnHead(
      [`${contact.id}.vcf`],
      author,
      author,
      `save_contact(${contact.id})`
    );
  });
});
