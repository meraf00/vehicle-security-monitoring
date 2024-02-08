import express from 'express';
import { expressjwt as jwt } from 'express-jwt';

import { Routes } from './controllers';
import mongoose from 'mongoose';

const app = express();
const port = process.env.PORT || 3000;

// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(
  jwt({
    secret: process.env.JWT_SECRET as string,
    algorithms: ['HS256'],
    maxAge: '',
  }).unless({ path: ['/auth/login', '/auth/register'] })
);

// Logging middleware
app.use((req, res, next) => {
  console.log(req.method, req.path);
  next();
});

// Routes
app.use('/auth', Routes.auth);

async function main() {
  await mongoose.connect(process.env.MONGO_URI as string);

  app.listen(port, () => {
    return console.log(
      `Express server is listening at http://localhost:${port} 🚀`
    );
  });
}

main();
