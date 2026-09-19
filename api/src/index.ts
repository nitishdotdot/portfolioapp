import express, { response } from "express";
import dotenv from "dotenv";
import bcrypt from "bcrypt";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "./generated/prisma/client.js";
import { OAuth2Client } from "google-auth-library";
import jwt from "jsonwebtoken";
import { stringify } from "node:querystring";
import { UserScalarFieldEnum } from "./generated/prisma/internal/prismaNamespace.js";
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
      if (!tokenResponse["payload"]["email_verified"]) {
        res.sendStatus(404);
        return;
      }
      const person = await prisma.user.findUnique({ where: { email: email } });
      if (person != null) {
        const token = jwt.sign(person, process.env.JWT_SECRET!);
        res.send(token);
        return;
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
      return;
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
app.post("/buyscrip", async (req, res) => {
  try {
    const jwtToken = req.headers["authorization"]?.split(" ")[1];
    if (jwtToken == null) {
      res.status(400).send("require token");
      return;
    }
    const decoded = jwt.verify(jwtToken, process.env.JWT_SECRET!.toString());

    const data = req.body;
    try {
      if (data.name && data.buyprice && data.kitta && data.buydatetime) {
        await prisma.scrip.create({
          data: {
            name: data.name,
            userid: Number((decoded as any).id),
            buyprice: data.buyprice,
            kitta: data.kitta,
            buydatetime: data.buydatetime,
            selldatetime: null,
            sellprice: 0,
          },
        });
        res.send("done");
      } else {
        res.send("wrong body");
      }
    } catch (e) {
      console.log(e);
      res.status(404).send("server error");
    }
  } catch (e) {
    res.status(400).send("invalid token");
  }
});
app.delete("/deletescrip", async (req, res) => {
  try {
    const jwtToken = req.headers["authorization"]?.split(" ")[1];
    if (jwtToken == null) {
      res.status(400).send("require token");
      return;
    }
    const decoded = jwt.verify(jwtToken, process.env.JWT_SECRET!.toString());
    const userid = (decoded as any).userid;
    const data = req.body;
    try {
      if (data.id) {
        await prisma.scrip.delete({
          where: { id: data.id, userid: data.userid },
        });
        res.send("done");
      } else {
        res.send("wrong body");
      }
    } catch (e) {
      console.log(e);
      res.status(404).send("server error");
    }
  } catch (e) {}
});
app.get("/user", async (req, res) => {
  try {
    const header = req.headers["authorization"];
    if (header == null) {
      res.status(404).send("require token");
      return;
    }
    const token = header.split(" ")[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET!.toString());
    const email = (decoded as any).email;
    try {
      const response = await prisma.user.findUnique({
        where: { email: email },
        select: {
          name: true,
          email: true,
          scrips: {
            select: {
              name: true,
              kitta: true,
              buyprice: true,
              buydatetime: true,
              selldatetime: true,
              sellprice: true,
            },
          },
        },
      });
      res.send(response);
    } catch (e) {
      console.log(e);
      res.status(404).send("server error");
    }
  } catch (e) {
    res.status(400).send("invalid token");
  }
});
app.use((req, res) => res.send("route not found"));
