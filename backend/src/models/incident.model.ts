import { Schema, model } from 'mongoose';

export interface IIncident {
  userEmail: string;
  vehiclePlate: string;
  imageUrl: string;
  location?: string;
  timestamp: Date;
}

const incidentSchema = new Schema<IIncident>({
  imageUrl: { type: String, required: true },
  location: { type: String, required: true },
  timestamp: { type: Date, required: true },
  vehiclePlate: { type: String, required: true },
  userEmail: { type: String, required: true },
});

export default model<IIncident>('Incident', incidentSchema);
