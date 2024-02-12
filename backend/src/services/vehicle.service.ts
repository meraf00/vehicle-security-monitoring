import vehicleModel from '../models/vehicle.model';
import incidentModel from '../models/incident.model';

const getVehicle = async (plate: string, userEmail: string) => {
  const vehicle = await vehicleModel.findOne({ plate, ownerEmail: userEmail });
  if (vehicle == null) throw new Error('Vehicle not found.');
  return vehicle;
};

const getVehicles = async (userEmail: string) => {
  const vehicles = await vehicleModel.find({ ownerEmail: userEmail });
  return vehicles;
};

const getIncidents = async (plate: string, userEmail: string) => {
  const vehicle = await getVehicle(plate, userEmail);
  const incidents = await incidentModel.find({
    vehiclePlate: vehicle.plate,
  });
  return incidents;
};

const addVehicle = async (plate: string, userEmail: string) => {
  const vehicle = new vehicleModel();
  vehicle.plate = plate;
  vehicle.ownerEmail = userEmail;
  return vehicle.save();
};

const removeVehicle = async (plate: string, userEmail: string) => {
  await vehicleModel.deleteOne({ plate });
};

export { addVehicle, removeVehicle, getVehicle, getVehicles, getIncidents };
