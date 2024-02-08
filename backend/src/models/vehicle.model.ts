import { Schema, model } from 'mongoose';
import { IUser } from './user.model';

export interface IVehicle {
  plate: string;
  location?: string;
  owner: IUser;
}

const vehicleSchema = new Schema<IVehicle>({
  plate: { type: String, required: true, unique: true },
  location: String,
  owner: { type: Schema.Types.ObjectId, ref: 'User' },
});

export default model<IVehicle>('Vehicle', vehicleSchema);
