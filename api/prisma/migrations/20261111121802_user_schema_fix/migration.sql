/*
  Warnings:

  - A unique constraint covering the columns `[phone]` on the table `user` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[Boid]` on the table `user` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "user" ADD COLUMN     "Boid" VARCHAR(16),
ADD COLUMN     "MemberSince" TIMESTAMP(3),
ADD COLUMN     "address" TEXT,
ADD COLUMN     "phone" VARCHAR(10);

-- CreateIndex
CREATE UNIQUE INDEX "user_phone_key" ON "user"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "user_Boid_key" ON "user"("Boid");
