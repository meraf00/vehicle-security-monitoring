import { z } from 'zod';

export const VehicleStatusReportSchema = z.object({
  body: z.object({
    vehiclePlate: z.string().min(1),
    location: z.string().min(1),
  }),
});
