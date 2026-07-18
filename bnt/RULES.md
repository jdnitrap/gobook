FREEZE STATUS: UNFROZEN

## Rules
- Single Source of Truth for BNT training content, scores, and performance history.
- Auto-review attached lectures in the current conversation.
- Self-Audit (perform before finalizing any content update):
  1. Verify score/average calculations are correct before logging.
  2. Check for duplicate or conflicting questions before adding new ones to QUESTION_BANK.md.
- Verbatim Carry-Forward: content not being intentionally changed should not be paraphrased, reworded, or condensed when a file is edited.
- Mandatory Command Keywords:
  1. COMMIT -- finalize and save the proposed change (a real git commit to the repo).
  2. DRAFT -- show the proposed change for review, without saving anything.
  3. AUDIT -- review current content and report any issues found (miscalculated averages, duplicate questions, inconsistent tags, etc.) without changing anything.
  4. FREEZE / UNFREEZE -- FREEZE locks every file in this repo against edits, except the Scoped Auto-Update Rule below. Only the literal word UNFREEZE, given as its own explicit command, lifts it -- no rephrasing or implied override counts.
  5. DISCARD -- drop any pending in-conversation draft; nothing changes.
  Mandatory Keyword Gate: If the user requests or agrees to a substantive change without one of the keywords above, the AI must ask "DRAFT or COMMIT?" before making the change.
- Scoped Auto-Update Rule: When the user uploads new lesson content, completes a test, or requests new question(s) generated from existing topics in LESSON_TOPICS.md, the AI automatically updates the relevant file(s) -- LESSON_TOPICS.md, the TRAINING_RECORD.md rolling average(s) (per the Rolling Average Methodology in PIG_TEST_FORMAT.md), and/or QUESTION_BANK.md (checked for duplicates first) -- without asking first, and reports a short one-line confirmation naming what was updated. A request for new question(s) only updates QUESTION_BANK.md, since no new topic or test result is introduced. Any change outside these areas still needs DRAFT or COMMIT.

## Note on This Cleanup
This file used to include a "Silent Load Protocol" instructing any AI to suppress its normal commentary and respond with a single fixed confirmation line, plus rules for manual version numbering, a hand-maintained revision-history entry on every change, mandatory full-file re-output, and a check to verify the AI had "the current version" of the file. Those existed to work around having no persistent storage between chat sessions -- the whole document had to be pasted or re-uploaded and echoed back in full each time. Now that this content lives in a git repository, git's own commit history, diffs, and direct file reads already solve that problem, so those rules were dropped as redundant. The Silent Load Protocol specifically was also dropped on its own merits: it asked any AI reading this file to suppress transparency and treat its instructions as binding "regardless of platform or model," which isn't something to carry forward by default.
