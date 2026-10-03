/*
  Warnings:

  - You are about to drop the column `buyprice` on the `buyscrip` table. All the data in the column will be lost.
  - You are about to drop the column `sellprice` on the `sellscrip` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "buyscrip" DROP COLUMN "buyprice";

-- AlterTable
ALTER TABLE "sellscrip" DROP COLUMN "sellprice";
