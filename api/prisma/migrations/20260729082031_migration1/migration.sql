-- CreateTable
CREATE TABLE "user" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "scrip" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "userid" INTEGER NOT NULL,
    "wacc" INTEGER NOT NULL,
    "kitta" INTEGER NOT NULL,
    "buydate" TIMESTAMP(3) NOT NULL,
    "selldate" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "scrip_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "scrip" ADD CONSTRAINT "scrip_userid_fkey" FOREIGN KEY ("userid") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
