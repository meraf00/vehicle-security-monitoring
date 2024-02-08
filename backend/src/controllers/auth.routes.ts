import express from 'express';
import { validate } from '../middlewares/validate';
import {
  RegisterSchema,
  LoginSchema,
} from '../middlewares/validators/user.validator';
import { register, login } from '../services/auth.service';

const router = express.Router();

router.post('/register', validate(RegisterSchema), async (req, res) => {
  const { email, password } = req.body;

  try {
    await register(email, password);
  } catch (error) {
    return res.status(400).json({ error: 'Email already exists.' });
  }

  return res.status(201).json({ message: 'User created successfully.' });
});

router.post('/login', validate(LoginSchema), async (req, res) => {
  const { email, password } = req.body;

  try {
    const token = await login(email, password);
    return res.status(200).json({ token });
  } catch (error) {
    return res.status(401).json({ error });
  }
});

export default router;
