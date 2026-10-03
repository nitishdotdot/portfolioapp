/*
  Warnings:

  - You are about to drop the `scrip` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "scrip" DROP CONSTRAINT "scrip_userid_fkey";

-- DropTable
DROP TABLE "scrip";

-- CreateTable
CREATE TABLE "buyscrip" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "userid" INTEGER NOT NULL,
    "buyprice" DECIMAL(10,3) NOT NULL,
    "kitta" INTEGER NOT NULL,
    "buydatetime" TIMESTAMP(3) NOT NULL,
    "wacc" DECIMAL(10,3) NOT NULL,
    "total" DECIMAL(10,3) NOT NULL,

    CONSTRAINT "buyscrip_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sellscrip" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "userid" INTEGER NOT NULL,
    "sellprice" DECIMAL(10,3) NOT NULL,
    "kitta" INTEGER NOT NULL,
    "selldatetime" TIMESTAMP(3) NOT NULL,
    "wacc" DECIMAL(10,3) NOT NULL,
    "total" DECIMAL(10,3) NOT NULL,
    "profit" DECIMAL(10,3) NOT NULL,

    CONSTRAINT "sellscrip_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "buyscrip" ADD CONSTRAINT "buyscrip_userid_fkey" FOREIGN KEY ("userid") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sellscrip" ADD CONSTRAINT "sellscrip_userid_fkey" FOREIGN KEY ("userid") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
