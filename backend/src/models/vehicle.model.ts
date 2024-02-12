import { Schema, model } from 'mongoose';

export interface IVehicle {
  plate: string;
  location?: string;
  ownerEmail: string;
}

const vehicleSchema = new Schema<IVehicle>({
  plate: { type: String, required: true, unique: true },
  location: String,
  ownerEmail: { type: String, required: true },
});

export default model<IVehicle>('Vehicle', vehicleSchema);
