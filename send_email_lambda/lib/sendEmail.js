const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "Gmail", // Use your email service provider
  auth: {
    user: process.env.EMAIL, // Your email
    pass: process.env.APP_PASSWORD, // Your email password or app-specific password
  },
});

async function sendEmail(email, password) {
  const body = `USERNAME: ${email} \nPASSWORD: ${password}`;
  console.log(body);

  console.log("sending email");
  const mailOptions = {
    from: process.env.EMAIL,
    to: email,
    subject: "AWS Workshop Account Credentials",
    text: body,
  };
  const response = await transporter.sendMail(mailOptions);

  console.log("mail sent");

  return response;
}

module.exports = { sendEmail };
