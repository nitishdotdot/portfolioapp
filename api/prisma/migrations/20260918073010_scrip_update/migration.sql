/*
  Warnings:

  - You are about to drop the column `buydate` on the `scrip` table. All the data in the column will be lost.
  - You are about to drop the column `selldate` on the `scrip` table. All the data in the column will be lost.
  - Added the required column `buydatetime` to the `scrip` table without a default value. This is not possible if the table is not empty.
  - Added the required column `selldatetime` to the `scrip` table without a default value. This is not possible if the table is not empty.
  - Added the required column `sellprice` to the `scrip` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "scrip" DROP COLUMN "buydate",
DROP COLUMN "selldate",
ADD COLUMN     "buydatetime" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "selldatetime" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "sellprice" INTEGER NOT NULL;
