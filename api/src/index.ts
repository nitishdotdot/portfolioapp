import express, { response } from "express";
import dotenv from "dotenv";
import bcrypt from "bcrypt";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "./generated/prisma/client.js";
const app = express();
dotenv.config();
const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });
const prisma = new PrismaClient({ adapter });
app.listen(process.env.PORT);
app.use(express.json());
app.get("/", (req, res) => res.send("server running"));
app.post("/user", async (req, res) => {
  const name = req.body.name;
  const email = req.body.email;
  const googleId = req.body.googleId;
  const photoUrl = req.body.photoUrl;
  if (name && email && googleId && photoUrl) {
    try {
      const user = await prisma.user.create({
        data: {
          name: name,
          email: email,
          photoUrl: photoUrl,
          googleId: googleId,
          password: "",
        },
      });
      res.send(user);
    } catch {
      res.send(req.body);
    }
  } else {
    res.send("wrong body");
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
        photoUrl: "",
        googleId: "",
      },
    });
    res.send(req.body);
  } else {
    res.send("wrong body");
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
