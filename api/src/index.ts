import express, { response } from "express";
import dotenv from "dotenv";
import bcrypt from "bcrypt";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "./generated/prisma/client.js";
import { OAuth2Client } from "google-auth-library";
import jwt from "jsonwebtoken";
import { stringify } from "node:querystring";
import { broadcast } from "node:stream/iter";
import { cp } from "node:fs";
import { Decimal } from "@prisma/client/runtime/client";
import { DatabaseSync } from "node:sqlite";
import { brotliDecompressSync } from "node:zlib";
import { json } from "node:stream/consumers";
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
  let role;
  if (req.body.role) {
    role = req.body.role;
  } else {
    role = "user";
  }
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
          role: role,
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
  let role;
  if (data.role) {
    role = data.role;
  } else {
    role = "user";
  }
  if (data.email && data.password && data.name) {
    await prisma.user.create({
      data: {
        name: data.name,
        email: data.email,
        password: await bcrypt.hash(data.password, 10),
        role: role,
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
    let wacc;
    try {
      if (data.name && data.buyprice && data.kitta && data.buydatetime) {
        const scripName = (data.name as string).trim().toUpperCase();
        const buyscripshistory = await prisma.buyscriphistory.findMany({
          where: { name: scripName, userid: Number((decoded as any).id) },
        });
        if (buyscripshistory.length > 0) {
          console.log("found");
          const buyscrip = await prisma.buyscrip.findFirst({
            where: { name: scripName, userid: Number((decoded as any).id) },
          });
          for (const scrips of buyscripshistory) {
            const date1 = data.buydatetime.split("T")[0];
            const date2 = scrips.buydatetime.toISOString().split("T")[0];
            if (date1 == date2) {
              const total0 = buyscrip!.total;
              const kitta0 = buyscrip!.kitta;
              const tax = await prisma.tax.findFirst({ where: { id: 1 } });
              const sebComm = tax?.sebComm as Decimal;
              const brComm = tax?.brComm as Decimal;
              const total1 =
                data.buyprice *
                  data.kitta *
                  Number(brComm?.plus(sebComm).times(1 / 100)) +
                data.buyprice * data.kitta;

              const total2 = total0.plus(total1);
              const kitta1 = kitta0 + data.kitta;
              const wacc = (total2 as Decimal).times(1 / kitta1);
              await prisma.buyscrip.update({
                where: { id: buyscrip!.id },
                data: {
                  kitta: kitta1,
                  wacc: wacc,
                  total: total2,
                },
              });
              await prisma.buyscriphistory.create({
                data: {
                  name: scripName,
                  userid: Number((decoded as any).id),
                  buyprice: data.buyprice,
                  kitta: data.kitta,
                  buydatetime: data.buydatetime,
                  wacc: total1 / data.kitta,
                  total: total1,
                },
              });
              res.send("ok");
              return;
            }
          }
          const total0 = buyscrip!.total;
          const kitta0 = buyscrip!.kitta;
          const tax = await prisma.tax.findFirst({ where: { id: 1 } });
          const sebComm = tax?.sebComm as Decimal;
          const brComm = tax?.brComm as Decimal;
          const dpCharge = tax?.dpCharge as number;
          const total1 =
            data.buyprice *
              data.kitta *
              Number(brComm?.plus(sebComm).times(1 / 100)) +
            dpCharge +
            data.buyprice * data.kitta;
          const total2 = total0.plus(total1);
          const kitta1 = kitta0 + data.kitta;
          const wacc = (total2 as Decimal).times(1 / kitta1);
          await prisma.buyscrip.update({
            where: { id: buyscrip!.id, userid: Number((decoded as any).id) },
            data: {
              kitta: kitta1,
              wacc: wacc,
              total: total2,
            },
          });
          await prisma.buyscriphistory.create({
            data: {
              name: scripName,
              userid: Number((decoded as any).id),
              buyprice: data.buyprice,
              kitta: data.kitta,
              buydatetime: data.buydatetime,
              wacc: total1 / data.kitta,
              total: total1,
            },
          });
          res.send("ok");
          return;
        }

        const tax = await prisma.tax.findFirst({ where: { id: 1 } });
        const sebComm = tax?.sebComm as Decimal;
        const brComm = tax?.brComm as Decimal;
        const dpCharge = tax?.dpCharge as number;
        const total =
          data.buyprice *
            data.kitta *
            Number(brComm?.plus(sebComm).times(1 / 100)) +
          dpCharge +
          data.buyprice * data.kitta;
        wacc = total / data.kitta;
        const name = (data.name as string).trim().toUpperCase();
        await prisma.buyscriphistory.create({
          data: {
            name: name,
            userid: Number((decoded as any).id),
            buyprice: data.buyprice,
            kitta: data.kitta,
            buydatetime: data.buydatetime,
            wacc: Number(wacc),
            total: total,
          },
        });
        await prisma.buyscrip.create({
          data: {
            name: name,
            userid: Number((decoded as any).id),
            kitta: data.kitta,
            wacc: Number(wacc),

            total: total,
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
// app.post("/sellscrip", async (req, res) => {
//   try {
//     const jwtToken = req.headers["authorization"]?.split(" ")[1];
//     if (jwtToken == null) {
//       res.status(400).send("require token");
//       return;
//     }
//     const decoded = jwt.verify(jwtToken, process.env.JWT_SECRET!.toString());
//     const data = req.body;
//     let wacc;
//     try {
//       if (data.name && data.sellscrip && data.kitta && data.selldatetime) {
//         const scripName = (data.name as string).trim().toUpperCase();
//         const user = await prisma.buyscrip.findFirst({
//           where: { name: scripName },
//         });
//         if (user != null) {
//           const user = prisma.sellscrip.findFirst({
//             where: { name: scripName },
//           });
//           if (user != null) {
//           }
//           //normal sell
//           res.send("ok");
//           return;
//         } else {
//           res.status(404).send("cannot sell before buy");
//           return;
//         }
//       } else {
//         res.send("wrong body");
//       }
//     } catch (e) {
//       console.log(e);
//       res.status(404).send("server error");
//     }
//   } catch (e) {
//     res.status(400).send("invalid token");
//   }
// });
app.delete("/deleteuser", async (req, res) => {
  try {
    const jwtToken = req.headers["authorization"]?.split(" ")[1];
    if (jwtToken == null) {
      res.status(400).send("require token");
      return;
    }
    const decoded = jwt.verify(jwtToken, process.env.JWT_SECRET!.toString());
    const id = Number((decoded as any).id);
    try {
      await prisma.buyscrip.deleteMany({ where: { userid: id } });
      await prisma.buyscriphistory.deleteMany({ where: { userid: id } });
      await prisma.user.delete({
        where: { id: id },
      });
      res.send("ok");
    } catch (e) {
      console.log(e);
      res.status(404).send("server error");
    }
  } catch (e) {}
});
// app.delete("/deletescrip", async (req, res) => {
//   try {
//     const jwtToken = req.headers["authorization"]?.split(" ")[1];
//     if (jwtToken == null) {
//       res.status(400).send("require token");
//       return;
//     }
//     const decoded = jwt.verify(jwtToken, process.env.JWT_SECRET!.toString());
//     const userid = (decoded as any).userid;
//     const data = req.body;
//     try {
//       if (data.id) {
//         await prisma.buyscrip.delete({
//           where: { id: data.id, userid: data.userid },
//         });
//         res.send("done");
//       } else {
//         res.send("wrong body");
//       }
//     } catch (e) {
//       console.log(e);
//       res.status(404).send("server error");
//     }
//   } catch (e) {}
// });
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
          buyscrips: {
            select: {
              name: true,
              kitta: true,
              wacc: true,
              total: true,
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
app.get("/alluser", async (req, res) => {
  try {
    const header = req.headers["authorization"];
    if (header == null) {
      res.status(404).send("require token");
      return;
    }
    const token = header.split(" ")[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET!.toString());
    const role = (decoded as any).role;
    if (role != "admin") {
      res.status(404).send("No Permission");
    }
    try {
      const response = await prisma.user.findMany({
        select: {
          name: true,
          email: true,
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
