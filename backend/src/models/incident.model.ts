import { Schema, model } from 'mongoose';
import { IVehicle } from './vehicle.model';

export interface IIncident {
  vehicle: IVehicle;
  capturedImage: string;
  location?: string;
  timestamp: Date;
}

const userSchema = new Schema<IIncident>({
  capturedImage: { type: String, required: true, unique: true },
  location: { type: String, required: true },
  timestamp: { type: Date, required: true },
  vehicle: { type: Schema.Types.ObjectId, ref: 'Vehicle' },
});

export default model<IIncident>('Incident', userSchema);
