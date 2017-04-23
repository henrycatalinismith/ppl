class UsageError extends Error {
  constructor(message) {
    super(message);
  }
}

module.exports = UsageError;
