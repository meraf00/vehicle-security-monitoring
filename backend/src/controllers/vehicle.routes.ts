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
} from '../services/vehicle.service';
import { IRequestWithAuth } from '../types/request';

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
    const vechicles = await getVehicle(plate, auth.email);
    return res.status(200).json(vechicles);
  } catch (error) {
    return res.status(400).json({ error: 'Vehicle already exist.' });
  }
});

router.get('/', async (req, res) => {
  const { auth } = req as IRequestWithAuth;
  try {
    const vehicles = await getVehicles(auth.email);
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

router.delete('/:id', validate(VehicleCreateSchema), async (req, res) => {
  const { auth } = req as IRequestWithAuth;
  const plate = req.params.id;

  try {
    await getVehicle(plate, auth.email);
    await removeVehicle(plate, auth.email);
    res.status(200).json({ message: 'Vehicle removed successfully.' });
  } catch (error) {
    return res.status(400).json({ error: "Vehicle doesn't exist." });
  }
});

export default router;
