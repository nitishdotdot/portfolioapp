/*
  Warnings:

  - You are about to alter the column `buyprice` on the `scrip` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,3)`.
  - You are about to alter the column `sellprice` on the `scrip` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(10,3)`.
  - You are about to alter the column `sebComm` on the `tax` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(5,3)`.
  - You are about to alter the column `brComm` on the `tax` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(5,3)`.
  - You are about to alter the column `shortTax` on the `tax` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(5,3)`.
  - You are about to alter the column `longTax` on the `tax` table. The data in that column could be lost. The data in that column will be cast from `Decimal(65,30)` to `Decimal(5,3)`.

*/
-- AlterTable
ALTER TABLE "scrip" ALTER COLUMN "buyprice" SET DATA TYPE DECIMAL(10,3),
ALTER COLUMN "sellprice" SET DATA TYPE DECIMAL(10,3);

-- AlterTable
ALTER TABLE "tax" ALTER COLUMN "sebComm" SET DATA TYPE DECIMAL(5,3),
ALTER COLUMN "brComm" SET DATA TYPE DECIMAL(5,3),
ALTER COLUMN "shortTax" SET DATA TYPE DECIMAL(5,3),
ALTER COLUMN "longTax" SET DATA TYPE DECIMAL(5,3);
