import nodemailer from 'nodemailer';

export interface MailData {
  to: string;
  subject: string;
  text: string;
}

const config = {
  service: 'gmail',
  host: 'smtp.gmail.com',
  port: 587,
  secure: false,
  auth: {
    user: process.env.EMAIL,
    pass: process.env.EMAIL_PASSWORD,
  },
};

const send = (data: MailData) => {
  const transporter = nodemailer.createTransport(config);

  return transporter.sendMail({
    from: process.env.EMAIL,
    to: data.to,
    subject: data.subject,
    text: data.text,
  });
};

export { send };
