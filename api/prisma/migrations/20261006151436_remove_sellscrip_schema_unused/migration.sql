/*
  Warnings:

  - You are about to drop the `sellscrip` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "sellscrip" DROP CONSTRAINT "sellscrip_userid_fkey";

-- DropTable
DROP TABLE "sellscrip";
