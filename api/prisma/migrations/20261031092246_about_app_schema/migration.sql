-- CreateTable
CREATE TABLE "aboutApp" (
    "id" SERIAL NOT NULL,
    "appName" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "tagline" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "developerName" TEXT NOT NULL,
    "supportEmail" TEXT NOT NULL,
    "website" TEXT NOT NULL,
    "disclaimer" TEXT NOT NULL,
    "features" JSONB NOT NULL,

    CONSTRAINT "aboutApp_pkey" PRIMARY KEY ("id")
);
