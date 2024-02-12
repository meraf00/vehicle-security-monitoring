import { z } from 'zod';

export const VehicleStatusReportSchema = z.object({
  body: z.object({
    vehiclePlate: z.string().min(1),
    location: z.string().min(1),
  }),
});

export const VehicleCreateSchema = z.object({
  body: z.object({
    plate: z.string().min(1),
    location: z.string().optional(),
  }),
});

export const VehicleGetIncidentsSchema = z.object({
  body: z.object({
    plate: z.string().min(1),
  }),
});

export const VehicleGetSchema = z.object({
  body: z.object({
    plate: z.string().min(1),
  }),
});
