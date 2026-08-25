/*
  Warnings:

  - You are about to drop the column `wacc` on the `scrip` table. All the data in the column will be lost.
  - Added the required column `buyprice` to the `scrip` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "scrip" DROP COLUMN "wacc",
ADD COLUMN     "buyprice" INTEGER NOT NULL;
