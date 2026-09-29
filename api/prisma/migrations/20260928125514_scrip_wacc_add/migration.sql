/*
  Warnings:

  - Added the required column `wacc` to the `scrip` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "scrip" ADD COLUMN     "wacc" DECIMAL(10,3) NOT NULL;
