/*
  Warnings:

  - Added the required column `email` to the `user` table without a default value. This is not possible if the table is not empty.
  - Added the required column `googgleId` to the `user` table without a default value. This is not possible if the table is not empty.
  - Added the required column `photoUrl` to the `user` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "user" ADD COLUMN     "email" TEXT NOT NULL,
ADD COLUMN     "googgleId" INTEGER NOT NULL,
ADD COLUMN     "photoUrl" TEXT NOT NULL;
