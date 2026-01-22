/*
  Warnings:

  - You are about to drop the column `contest_id` on the `dsa_problem` table. All the data in the column will be lost.
  - You are about to drop the column `memory_limit` on the `dsa_problem` table. All the data in the column will be lost.
  - You are about to drop the column `time_limit` on the `dsa_problem` table. All the data in the column will be lost.
  - You are about to drop the column `execution_time` on the `dsa_submission` table. All the data in the column will be lost.
  - You are about to drop the column `points_earned` on the `dsa_submission` table. All the data in the column will be lost.
  - You are about to drop the column `test_cases_passed` on the `dsa_submission` table. All the data in the column will be lost.
  - You are about to drop the column `total_test_cases` on the `dsa_submission` table. All the data in the column will be lost.
  - You are about to drop the column `contest_id` on the `mcq_question` table. All the data in the column will be lost.
  - You are about to drop the column `correct_option_index` on the `mcq_question` table. All the data in the column will be lost.
  - You are about to drop the column `question_text` on the `mcq_question` table. All the data in the column will be lost.
  - You are about to drop the column `is_correct` on the `mcq_submission` table. All the data in the column will be lost.
  - You are about to drop the column `points_earned` on the `mcq_submission` table. All the data in the column will be lost.
  - You are about to drop the column `selected_option_index` on the `mcq_submission` table. All the data in the column will be lost.
  - You are about to drop the column `expected_output` on the `test_case` table. All the data in the column will be lost.
  - You are about to drop the column `is_hidden` on the `test_case` table. All the data in the column will be lost.
  - Added the required column `contestId` to the `dsa_problem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `executionTime` to the `dsa_submission` table without a default value. This is not possible if the table is not empty.
  - Added the required column `contestId` to the `mcq_question` table without a default value. This is not possible if the table is not empty.
  - Added the required column `correctOptionIndex` to the `mcq_question` table without a default value. This is not possible if the table is not empty.
  - Added the required column `questionText` to the `mcq_question` table without a default value. This is not possible if the table is not empty.
  - Added the required column `isCorrect` to the `mcq_submission` table without a default value. This is not possible if the table is not empty.
  - Added the required column `selectedOptionIndex` to the `mcq_submission` table without a default value. This is not possible if the table is not empty.
  - Added the required column `expectedOutput` to the `test_case` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "dsa_problem" DROP CONSTRAINT "dsa_problem_contest_id_fkey";

-- DropForeignKey
ALTER TABLE "mcq_question" DROP CONSTRAINT "mcq_question_contest_id_fkey";

-- AlterTable
ALTER TABLE "dsa_problem" DROP COLUMN "contest_id",
DROP COLUMN "memory_limit",
DROP COLUMN "time_limit",
ADD COLUMN     "contestId" INTEGER NOT NULL,
ADD COLUMN     "memoryLimit" INTEGER NOT NULL DEFAULT 256,
ADD COLUMN     "timeLimit" INTEGER NOT NULL DEFAULT 2000;

-- AlterTable
ALTER TABLE "dsa_submission" DROP COLUMN "execution_time",
DROP COLUMN "points_earned",
DROP COLUMN "test_cases_passed",
DROP COLUMN "total_test_cases",
ADD COLUMN     "executionTime" INTEGER NOT NULL,
ADD COLUMN     "pointsEarned" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "testCasesPassed" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "totalTestCases" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "mcq_question" DROP COLUMN "contest_id",
DROP COLUMN "correct_option_index",
DROP COLUMN "question_text",
ADD COLUMN     "contestId" INTEGER NOT NULL,
ADD COLUMN     "correctOptionIndex" INTEGER NOT NULL,
ADD COLUMN     "questionText" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "mcq_submission" DROP COLUMN "is_correct",
DROP COLUMN "points_earned",
DROP COLUMN "selected_option_index",
ADD COLUMN     "isCorrect" BOOLEAN NOT NULL,
ADD COLUMN     "pointsEarned" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "selectedOptionIndex" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "test_case" DROP COLUMN "expected_output",
DROP COLUMN "is_hidden",
ADD COLUMN     "expectedOutput" JSONB NOT NULL,
ADD COLUMN     "isHidden" BOOLEAN NOT NULL DEFAULT false;

-- AddForeignKey
ALTER TABLE "mcq_question" ADD CONSTRAINT "mcq_question_contestId_fkey" FOREIGN KEY ("contestId") REFERENCES "Contest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dsa_problem" ADD CONSTRAINT "dsa_problem_contestId_fkey" FOREIGN KEY ("contestId") REFERENCES "Contest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
