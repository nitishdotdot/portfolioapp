-- CreateTable
CREATE TABLE "tax" (
    "id" SERIAL NOT NULL,
    "sebComm" INTEGER NOT NULL,
    "brComm" INTEGER NOT NULL,
    "dpCharge" INTEGER NOT NULL,
    "shortTax" INTEGER NOT NULL,
    "longTax" INTEGER NOT NULL,

    CONSTRAINT "tax_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "tax_id_key" ON "tax"("id");
