import express from 'express';
import { expressjwt as jwt } from 'express-jwt';

import mongoose from 'mongoose';

const app = express();
const server = require('http').createServer(app);
const io = require('socket.io')(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});
const port = process.env.PORT || 3000;

import { Routes } from './controllers';

// Logging middleware
app.use((req, res, next) => {
  console.log(req.method, req.path);
  next();
});

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

// Routes
app.use('/auth', Routes.auth);
app.use('/vehicles', Routes.vehicles);

// Socket.io Handlers
io.on('connection', Routes.socketHandler);

async function main() {
  await mongoose.connect(process.env.MONGO_URI as string);

  server.listen(port, () => {
    return console.log(
      `Express server is listening at http://localhost:${port} 🚀`
    );
  });
}

main();
