const vCard = require('vcf');

class Contact {
  static create (id, name) {
    const card = new vCard;
    const contact = new Contact(id, card);
    card.set('fn', name);
    return contact;
  }

  constructor(id, card) {
    this.id = id;
    this.card = card;
  }
}

module.exports = Contact;
