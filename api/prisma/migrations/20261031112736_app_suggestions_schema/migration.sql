-- CreateTable
CREATE TABLE "appSuggestions" (
    "id" SERIAL NOT NULL,
    "suggestion" TEXT NOT NULL,
    "datetime" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "appSuggestions_pkey" PRIMARY KEY ("id")
);
