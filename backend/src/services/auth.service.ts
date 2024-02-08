import userModel, { IUser } from '../models/user.model';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';

const generateToken = (email: string) => {
  const payload = {
    email,
  };

  return jwt.sign(payload, process.env.JWT_SECRET as string, {
    expiresIn: process.env.JWT_EXPIRES_IN,
  });
};

const verify = async (email: string, password: string) => {
  const user = await userModel.findOne({ email });

  if (user == null) return false;

  return bcrypt.compareSync(password, user.password);
};

const register = async (email: string, password: string) => {
  const salt = bcrypt.genSaltSync(10);
  const hashedPassword = bcrypt.hashSync(password, salt);

  const user = new userModel({
    email,
    password: hashedPassword,
  });

  return user.save();
};

const login = async (email: string, password: string) => {
  const isUserValid = await verify(email, password);

  if (!isUserValid) {
    throw new Error('Invalid email or password.');
  }

  return generateToken(email);
};

export { login, register };
