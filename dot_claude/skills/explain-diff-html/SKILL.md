---
name: explain-diff-html
description: Use when the user asks for a rich explanation of a code change,
  diff, branch, or PR. Produces HTML output.
---

# Explain diff

Make a rich, interactive explanation of the specified code change.

It should have these sections:

- Background: explain the existing system relevant to this change. (You should
  broadly explore surrounding code for this.) It's unknown how much the reader
  already knows, so include a deep background for beginners (note that it can be
  skipped if the reader is already familiar), and then a more narrow background
  directly relevant to the change.
- Intuition: explain the core intuition for the code change. The focus here is
  to explain the essence instead of the full details. Use concrete examples with
  toy data. Use figures and diagrams liberally.
- Code: do a high-level walkthrough of the changes to the code. Group/order the
  changes in an understandable way.
- Quiz: come up with five questions that test the reader's knowledge of this PR.
  This should be medium difficulty, difficult enough that you actually need to
  understand the substance of the PR to answer them, but not gotchas. The goal
  is to help the reader make sure that they've actually understood. The
  questions should be interactive multiple-choice questions, and when the user
  clicks, show whether they were correct and give feedback.

Format:

- Output one self-contained HTML file which includes CSS and JavaScript.
  Make the whole thing one long page with section headers and a table of
  contents. Don't use tabs for the top-level structure. Basic responsive
  styling so you can view it on a phone is nice too. Put the file in a global
  place on the host outside of the code repo, and make sure the filename always
  starts with today's date in `YYYY-MM-DD-` format, because it helps keep the
  files time-sorted and out of version control. An example filename:
  `/tmp/2026-01-12-explanation-<slug>.html`
- Write with the clarity and flow of Martin Kleppmann. Make the text engaging
  and written in classic style. Transitions between sections should be smooth.
- Some tips on diagrams. Ideally, you should pick a small number of diagram
  families and reuse them throughout the explanation. Some useful kinds of
  diagrams:
  - A very simplified version of the app's UI, to explain UI changes.
  - A system diagram showing data flow or communication between components. Make
    sure to include example data here.
- Don't draw diagrams with plain-text characters. Always use simple HTML designs
  for your diagrams, HTML lists for lists of things, etc.
  - For code blocks, always use `<pre>` tags. If you use a custom styled div
    instead, it **must** have
    `white-space: pre-wrap` in its CSS, or the browser collapses all newlines
    into one line.
    Before saving the file, scan each code block in the HTML source and confirm
    its CSS includes
    `white-space: pre` or `pre-wrap`.
- Use callouts for key concepts or definitions, important edge cases, etc.
