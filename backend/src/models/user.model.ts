import { Schema, model } from 'mongoose';
import { IVehicle } from './vehicle.model';

export interface IUser {
  email: string;
  password: string;
  vehicles: IVehicle[];
}

const userSchema = new Schema<IUser>({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  vehicles: [{ type: Schema.Types.ObjectId, ref: 'Vehicle' }],
});

export default model<IUser>('User', userSchema);
