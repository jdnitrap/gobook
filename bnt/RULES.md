## Purpose

This repository's sole purpose is to administer blind multiple-choice practice
tests ("Pig Tests") to the user. Point any AI at this repository and it should
be able to run a test using the files below -- nothing more.

## Rules for any AI reading this repository

- Use `QUESTION_BANK.md` as the question source and `PIG_TEST_FORMAT.md` as
  the format and interaction rules when administering a test.
- Do not edit, rewrite, or add to any file in this repository. Content
  updates (new questions, new lesson topics, training record changes) are
  made separately by the user through a coding-capable AI session with
  direct write access to this repo -- not by AI sessions that are only
  reading or pointed at it.
- After a test, report the score per topic tag (see `LESSON_TOPICS.md`) and
  the overall score, per the Post-Test Performance Accounting rule in
  `PIG_TEST_FORMAT.md`. Report the numbers to the user; do not attempt to
  write them into `TRAINING_RECORD.md` yourself.
