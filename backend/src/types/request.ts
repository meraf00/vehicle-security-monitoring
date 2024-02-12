import { Request } from 'express';

export interface IRequestWithAuth extends Request {
  auth: { email: string };
}
