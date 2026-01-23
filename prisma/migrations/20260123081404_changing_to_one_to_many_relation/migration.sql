/*
  Warnings:

  - A unique constraint covering the columns `[user_id,question_id]` on the table `mcq_submission` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "dsa_submission" DROP CONSTRAINT "dsa_submission_problem_id_fkey";

-- DropForeignKey
ALTER TABLE "dsa_submission" DROP CONSTRAINT "dsa_submission_user_id_fkey";

-- DropForeignKey
ALTER TABLE "mcq_submission" DROP CONSTRAINT "mcq_submission_question_id_fkey";

-- DropForeignKey
ALTER TABLE "mcq_submission" DROP CONSTRAINT "mcq_submission_user_id_fkey";

-- DropIndex
DROP INDEX "dsa_submission_problem_id_key";

-- DropIndex
DROP INDEX "dsa_submission_user_id_key";

-- DropIndex
DROP INDEX "mcq_submission_question_id_key";

-- DropIndex
DROP INDEX "mcq_submission_user_id_key";

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "dsa_submissionId" INTEGER,
ADD COLUMN     "mcq_submissionId" INTEGER;

-- AlterTable
ALTER TABLE "dsa_problem" ADD COLUMN     "dsa_submissionId" INTEGER;

-- AlterTable
ALTER TABLE "mcq_question" ADD COLUMN     "mcq_submissionId" INTEGER;

-- CreateIndex
CREATE UNIQUE INDEX "mcq_submission_user_id_question_id_key" ON "mcq_submission"("user_id", "question_id");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_mcq_submissionId_fkey" FOREIGN KEY ("mcq_submissionId") REFERENCES "mcq_submission"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_dsa_submissionId_fkey" FOREIGN KEY ("dsa_submissionId") REFERENCES "dsa_submission"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mcq_question" ADD CONSTRAINT "mcq_question_mcq_submissionId_fkey" FOREIGN KEY ("mcq_submissionId") REFERENCES "mcq_submission"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dsa_problem" ADD CONSTRAINT "dsa_problem_dsa_submissionId_fkey" FOREIGN KEY ("dsa_submissionId") REFERENCES "dsa_submission"("id") ON DELETE SET NULL ON UPDATE CASCADE;
