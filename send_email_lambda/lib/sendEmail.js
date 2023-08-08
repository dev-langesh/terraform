const nodemailer = require("nodemailer");

async function sendEmail(email, password) {
  const body = ` USERNAME: ${email} \nPASSWORD: ${password}`;
  console.log(body);

  // Set up Nodemailer transporter
  const transporter = nodemailer.createTransport({
    service: "Gmail", // Use your email service provider
    auth: {
      user: process.env.EMAIL, // Your email
      pass: process.env.APP_PASSWORD, // Your email password or app-specific password
    },
  });

  try {
    // Send email
    await transporter.sendMail({
      from: process.env.EMAIL,
      to: email,
      subject: "AWS Workshop Account Credentials",
      text: body,
    });

    console.log({ message: "Email sent successfully" });
  } catch (error) {
    console.error(error);
    console.log({ message: "Error sending email" });
  }
}

module.exports = { sendEmail };
