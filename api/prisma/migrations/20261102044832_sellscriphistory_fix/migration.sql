/*
  Warnings:

  - Added the required column `holding` to the `sellscriphistory` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "sellscriphistory" ADD COLUMN     "holding" INTEGER NOT NULL;
