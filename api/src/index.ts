import express, { response } from "express";
import dotenv from "dotenv";
import bcrypt from "bcrypt";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "./generated/prisma/client.js";
import { OAuth2Client } from "google-auth-library";
import jwt from "jsonwebtoken";
const app = express();
dotenv.config();
const googleAuth = new OAuth2Client(
  process.env.CLIENT_ID,
  process.env.SERVER_ID,
);
const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });
const prisma = new PrismaClient({ adapter });
app.listen(process.env.PORT);
app.use(express.json());
app.get("/", (req, res) => res.send("server running"));
app.post("/googlesignin", async (req, res) => {
  const name = req.body.name;
  const email = req.body.email;
  const googleId = req.body.googleId;
  const photoUrl = req.body.photoUrl;
  const idToken = req.body.idToken;
  const tokenResponse = await googleAuth.verifyIdToken({
    idToken: idToken,
  });
  if (name && email && googleId && photoUrl && idToken) {
    try {
      if (!tokenResponse["payload"]["email_verified"]) res.sendStatus(404);
      const person = await prisma.user.findUnique({ where: { email: email } });
      if (person != null) {
        const token = jwt.sign(person, process.env.JWT_SECRET!);
        res.send(token);
      }
      const user = await prisma.user.create({
        data: {
          name: name,
          email: email,
          photoUrl: photoUrl,
          googleId: googleId,
          idToken: idToken,
        },
      });
      const token = jwt.sign(user, process.env.JWT_SECRET!);
      res.send(token);
    } catch (e) {
      res.sendStatus(400);
    }
  } else {
    res.sendStatus(404);
  }
});
app.post("/signup", async (req, res) => {
  const data = req.body;
  if (data.email && data.password && data.name) {
    await prisma.user.create({
      data: {
        name: data.name,
        email: data.email,
        password: await bcrypt.hash(data.password, 10),
      },
    });
    res.sendStatus(200);
  } else {
    res.sendStatus(400);
  }
});
app.post("/signin", async (req, res) => {
  const data = req.body;
  if (data.email && data.password) {
    const user = await prisma.user.findUnique({ where: { email: data.email } });
    if (user == null) {
      res.sendStatus(404);
    } else {
      const token = jwt.sign(user, process.env.JWT_SECRET!);
      const x = await bcrypt.compare(data.password, user.password!);
      if (x) {
        res.send(token);
      } else res.sendStatus(400);
    }
  } else {
    res.sendStatus(400);
  }
});
app.post("/scrip", async (req, res) => {
  const data = req.body;
  if (
    data.name &&
    data.userid &&
    data.buyprice &&
    data.kitta &&
    data.buydate &&
    data.selldate
  ) {
    await prisma.scrip.create({
      data: {
        name: data.name,
        userid: data.userid,
        buyprice: data.buyprice,
        kitta: data.kitta,
        buydate: data.buydate,
        selldate: data.selldate,
      },
    });
    res.send("done");
  } else {
    res.send("wrong body");
  }
});
app.get("/user", async (req, res) => {
  const email = req.body.email;
  const response = await prisma.user.findMany({ where: { email: email } });
  res.send(response);
});
app.use((req, res) => res.send("route not found"));
