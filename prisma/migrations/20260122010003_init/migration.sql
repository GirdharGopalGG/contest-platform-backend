-- CreateEnum
CREATE TYPE "role" AS ENUM ('creator', 'contestee');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "role" NOT NULL DEFAULT 'contestee',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Contest" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "creator_id" INTEGER NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "end_time" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Contest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcq_question" (
    "id" SERIAL NOT NULL,
    "contest_id" INTEGER NOT NULL,
    "question_text" TEXT NOT NULL,
    "options" JSONB NOT NULL,
    "correct_option_index" INTEGER NOT NULL,
    "points" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "mcq_question_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dsa_problem" (
    "id" SERIAL NOT NULL,
    "contest_id" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "tags" JSONB NOT NULL,
    "points" INTEGER NOT NULL DEFAULT 100,
    "time_limit" INTEGER NOT NULL DEFAULT 2000,
    "memory_limit" INTEGER NOT NULL DEFAULT 256,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "dsa_problem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "test_case" (
    "id" SERIAL NOT NULL,
    "problem_id" INTEGER NOT NULL,
    "input" JSONB NOT NULL,
    "expected_output" JSONB NOT NULL,
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "test_case_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mcq_submission" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "question_id" INTEGER NOT NULL,
    "selected_option_index" INTEGER NOT NULL,
    "is_correct" BOOLEAN NOT NULL,
    "points_earned" INTEGER NOT NULL DEFAULT 0,
    "submitted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "mcq_submission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dsa_submission" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "problem_id" INTEGER NOT NULL,
    "code" TEXT NOT NULL,
    "language" VARCHAR(50) NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "points_earned" INTEGER NOT NULL DEFAULT 0,
    "test_cases_passed" INTEGER NOT NULL DEFAULT 0,
    "total_test_cases" INTEGER NOT NULL DEFAULT 0,
    "execution_time" INTEGER NOT NULL,
    "submitted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "dsa_submission_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "mcq_submission_user_id_key" ON "mcq_submission"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "mcq_submission_question_id_key" ON "mcq_submission"("question_id");

-- CreateIndex
CREATE UNIQUE INDEX "dsa_submission_user_id_key" ON "dsa_submission"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "dsa_submission_problem_id_key" ON "dsa_submission"("problem_id");

-- AddForeignKey
ALTER TABLE "Contest" ADD CONSTRAINT "Contest_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mcq_question" ADD CONSTRAINT "mcq_question_contest_id_fkey" FOREIGN KEY ("contest_id") REFERENCES "Contest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dsa_problem" ADD CONSTRAINT "dsa_problem_contest_id_fkey" FOREIGN KEY ("contest_id") REFERENCES "Contest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "test_case" ADD CONSTRAINT "test_case_problem_id_fkey" FOREIGN KEY ("problem_id") REFERENCES "dsa_problem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mcq_submission" ADD CONSTRAINT "mcq_submission_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mcq_submission" ADD CONSTRAINT "mcq_submission_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "mcq_question"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dsa_submission" ADD CONSTRAINT "dsa_submission_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dsa_submission" ADD CONSTRAINT "dsa_submission_problem_id_fkey" FOREIGN KEY ("problem_id") REFERENCES "dsa_problem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
