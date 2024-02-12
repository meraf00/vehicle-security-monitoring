import { Request, Response, NextFunction } from 'express';
import { Schema } from 'zod';

const validate =
  (schema: Schema) => (req: Request, res: Response, next: NextFunction) => {
    try {
      schema.parse({
        body: req.body,
        query: req.query,
        params: req.params,
      });

      next();
    } catch (err: any) {
      console.log(err.errors);
      return res.status(400).send(err.errors);
    }
  };

export { validate };
