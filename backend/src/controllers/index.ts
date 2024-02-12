import auth from './auth.routes';
import vehicles from './vehicle.routes';
import socketHandler from './socket.controller';

export const Routes = {
  auth,
  vehicles,
  socketHandler,
};
