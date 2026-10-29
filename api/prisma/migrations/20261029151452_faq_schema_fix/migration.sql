/*
  Warnings:

  - You are about to drop the column `ansewer` on the `faq` table. All the data in the column will be lost.
  - Added the required column `answer` to the `faq` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "faq" DROP COLUMN "ansewer",
ADD COLUMN     "answer" TEXT NOT NULL;
