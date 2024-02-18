import express from 'express';
import { validate } from '../middlewares/validate';
import {
  VehicleCreateSchema,
  VehicleStatusReportSchema,
} from '../middlewares/validators/vehicle.validator';
import {
  addVehicle,
  getVehicle,
  getVehicles,
  removeVehicle,
  createIncident,
  getIncidents,
} from '../services/vehicle.service';
import { IRequestWithAuth } from '../types/request';
import { send } from '../services/mail.service';

const router = express.Router();

router.post(
  '/monitor',
  validate(VehicleStatusReportSchema),
  async (req, res) => {
    //
  }
);

router.get('/:id', async (req, res) => {
  const { auth } = req as any;
  const plate = req.params.id;

  try {
    const vehicle = await getVehicle(plate, auth.email);

    vehicle.incidents = await getIncidents(vehicle.plate, auth.email);

    return res.status(200).json(vehicle);
  } catch (error) {
    return res.status(400).json({ error: 'Vehicle already exist.' });
  }
});

router.get('/', async (req, res) => {
  const { auth } = req as IRequestWithAuth;
  try {
    const vehicles = await getVehicles(auth.email);
    for (const vehicle of vehicles) {
      vehicle.incidents = await getIncidents(vehicle.plate, auth.email);
    }
    return res.status(200).json({ vehicles });
  } catch (error) {
    return res.status(400).json({ error: 'Vehicle already exist.' });
  }
});

router.post('/', validate(VehicleCreateSchema), async (req, res) => {
  const { auth } = req as IRequestWithAuth;
  const { plate } = req.body;

  try {
    await addVehicle(plate, auth.email);
    res.status(200).json({ message: 'Vehicle added successfully.' });
  } catch (error) {
    return res.status(400).json({ error: 'Vehicle already exist.' });
  }
});

router.delete('/:id', async (req, res) => {
  const { auth } = req as any;
  const plate = req.params.id;

  try {
    await getVehicle(plate, auth.email);
    await removeVehicle(plate, auth.email);
    res.status(200).json({ message: 'Vehicle removed successfully.' });
  } catch (error) {
    return res.status(400).json({ error: "Vehicle doesn't exist." });
  }
});

router.get('/:id/incidents', async (req, res) => {
  const { auth } = req as any;
  const plate = req.params.id;

  try {
    const incidents = await getIncidents(plate, auth.email);
    return res.status(200).json({ incidents });
  } catch (error) {
    return res.status(400).json({ error: 'Vehicle not found.' });
  }
});

router.post('/:id/incidents', async (req, res) => {
  const { auth } = req as any;
  const { location, imageUrl } = req.body;
  const plate = req.params.id;

  console.log(auth, location, plate, imageUrl);

  try {
    await createIncident(auth.email, plate, location, imageUrl);
    await send({
      to: auth.email,
      subject: 'Incident reported',
      html: `<p>An incident was reported for vehicle ${plate}.</p><a href="${imageUrl}">Image</a><img src="${imageUrl}" />`,
    });
    res.status(200).json({ message: 'Incident created successfully.' });
  } catch (error) {
    console.log(error);
    return res.status(400).json({ error: 'Incident already exist.' });
  }
});

export default router;
