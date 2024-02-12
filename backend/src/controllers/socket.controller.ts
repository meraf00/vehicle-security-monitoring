import { Socket } from 'socket.io';
import { JwtPayload, verify } from 'jsonwebtoken';

interface IVehicleStatus {
  email: string;
  plate: string;
  longitude: string;
  latitude: string;
}

export const socketHandler = (socket: Socket) => {
  try {
    const decoded = verify(
      socket.handshake.headers.authorization ?? '',
      process.env.JWT_SECRET as string
    );
    const user = decoded as JwtPayload;
    console.log('Client connected:', user.email);
    socket.join(user.email);
  } catch (err) {
    console.error('Error:', err);
    socket.disconnect();
  }

  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });

  socket.on('vehicle_status', (status: IVehicleStatus) => {
    socket.broadcast.to(status.email).emit('vehicle_status', status);
    console.log(
      'Vehicle status:',
      status.plate,
      status.longitude,
      status.latitude
    );
  });

  socket.on('unlock', (data) => {
    socket.broadcast.to(data.email).emit('unlock', data.plate);
    console.log('Unlocking vehicle');
  });

  socket.on('lock', (data) => {
    socket.broadcast.to(data.email).emit('unlock', data.plate);
    console.log('Unlocking vehicle');
  });
};

export default socketHandler;
