import { Schema, model } from 'mongoose';
import { IIncident } from './incident.model';

export interface IVehicle {
  plate: string;
  location?: string;
  ownerEmail: string;
  incidents: IIncident[];
}

const vehicleSchema = new Schema<IVehicle>({
  plate: { type: String, required: true, unique: true },
  location: String,
  ownerEmail: { type: String, required: true },
  incidents: [{ type: Schema.Types.ObjectId, ref: 'Incident', default: [] }],
});

export default model<IVehicle>('Vehicle', vehicleSchema);
