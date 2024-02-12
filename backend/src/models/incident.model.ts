import { Schema, model } from 'mongoose';

export interface IIncident {
  userEmail: string;
  vehiclePlate: string;
  capturedImage: string;
  location?: string;
  timestamp: Date;
}

const userSchema = new Schema<IIncident>({
  capturedImage: { type: String, required: true, unique: true },
  location: { type: String, required: true },
  timestamp: { type: Date, required: true },
  vehiclePlate: { type: String, required: true },
  userEmail: { type: String, required: true },
});

export default model<IIncident>('Incident', userSchema);
