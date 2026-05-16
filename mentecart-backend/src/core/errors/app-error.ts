export class AppError extends Error {
  constructor(
    public readonly message: string,
    public readonly statusCode = 500,
    public readonly errorCode = 'INTERNAL_SERVER_ERROR',
  ) {
    super(message);
    Object.setPrototypeOf(this, AppError.prototype);
  }
}
