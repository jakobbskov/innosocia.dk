# Status updates

`src/data/updates.json` feeds the public `/status/` page.

The file is not a commit log. It is a short, human-readable changelog for visitors.

## When to add an update

Add an entry when a change is visible or meaningful to a visitor.

Examples:

- a page is added or substantially rewritten
- navigation or mobile layout is improved
- dead links are removed
- a new app, project or article is published
- downloads, public files or documentation become available
- status or project information becomes clearer

Do not add an entry for internal-only changes.

Examples:

- small refactors
- dependency updates with no visible effect
- deploy-script fixes that only affect operations
- wording changes that do not change meaning
- formatting-only changes

## Tone

Write in plain language.

Good example:

Forsiden fungerer bedre på mobil.

Avoid:

Mobile hero layout validation has been improved through responsive rendering adjustments.

Visitors do not need a build log with perfume on it.

## Entry format

Each entry must include:

- date in `YYYY-MM-DD` format
- area, for example `Website`, `Apps`, `Downloads` or `Projects`
- title as a short title
- summary as one short sentence about what changed

Keep entries short. If the explanation needs several paragraphs, it probably belongs in an article or project page instead.

## Practical rule

For every user-facing change, ask:

Would a visitor reasonably care or notice?

If yes, update `src/data/updates.json`.

If no, leave it out.
