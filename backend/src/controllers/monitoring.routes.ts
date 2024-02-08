import express from 'express';
import { validate } from '../middlewares/validate';
import { VehicleStatusReportSchema } from '../middlewares/validators/monitoring.validator';

const router = express.Router();

router.post(
  '/monitor',
  validate(VehicleStatusReportSchema),
  async (req, res) => {
    const { vehiclePlate, location } = req.body;

    try {
      // await register(email, password);
    } catch (error) {
      return res.status(400).json({ error: 'Email already exists.' });
    }
  }
);
