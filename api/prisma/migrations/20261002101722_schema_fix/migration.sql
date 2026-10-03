/*
  Warnings:

  - You are about to drop the column `buydatetime` on the `buyscrip` table. All the data in the column will be lost.
  - You are about to drop the column `selldatetime` on the `sellscrip` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "buyscrip" DROP COLUMN "buydatetime";

-- AlterTable
ALTER TABLE "sellscrip" DROP COLUMN "selldatetime";

-- CreateTable
CREATE TABLE "buyscriphistory" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "userid" INTEGER NOT NULL,
    "buyprice" DECIMAL(10,3) NOT NULL,
    "kitta" INTEGER NOT NULL,
    "buydatetime" TIMESTAMP(3) NOT NULL,
    "wacc" DECIMAL(10,3) NOT NULL,
    "total" DECIMAL(10,3) NOT NULL,

    CONSTRAINT "buyscriphistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sellscriphistory" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "userid" INTEGER NOT NULL,
    "sellprice" DECIMAL(10,3) NOT NULL,
    "kitta" INTEGER NOT NULL,
    "selldatetime" TIMESTAMP(3) NOT NULL,
    "wacc" DECIMAL(10,3) NOT NULL,
    "total" DECIMAL(10,3) NOT NULL,
    "profit" DECIMAL(10,3) NOT NULL,

    CONSTRAINT "sellscriphistory_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "buyscriphistory" ADD CONSTRAINT "buyscriphistory_userid_fkey" FOREIGN KEY ("userid") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sellscriphistory" ADD CONSTRAINT "sellscriphistory_userid_fkey" FOREIGN KEY ("userid") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
