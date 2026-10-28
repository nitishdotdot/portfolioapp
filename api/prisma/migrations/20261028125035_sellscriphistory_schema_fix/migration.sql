/*
  Warnings:

  - Added the required column `profitPercent` to the `sellscriphistory` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "sellscriphistory" ADD COLUMN     "profitPercent" DECIMAL(10,3) NOT NULL;
