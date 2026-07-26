# Guide for AI agents (and humans) working in this repo

This repo holds **curated, annotated reading lists** organized by area. The goal:
for each topic, a printable **reading guide** plus a reproducible way to fetch the
underlying papers/books. Keep contributions consistent with the conventions below.

This is the canonical agent guide; `CLAUDE.md` just points here.

## Golden rules

1. **Never commit third-party PDFs.** Papers and books are copyrighted even when
   free to read. Commit only *our* material (guides, scripts, notes). Everything
   else is referenced by URL and downloaded by a topic's `fetch.sh` into a
   git-ignored `pdfs/` directory.
2. **The README is the single source of truth; the HTML is generated.** Each topic's
   `reading-guide.html` is produced from its `README.md` by `bin/gen-guide.py` — so
   the two never drift and both carry the same papers/books. **Never hand-edit
   `reading-guide.html`;** edit the README and regenerate. `reading-guide.pdf` is a
   build artifact (`make`) and is git-ignored — never commit it.
3. **Reuse the house style.** Guides link the shared stylesheet (`lib/guide.css`);
   do not fork per-guide CSS. `bin/render.sh` inlines it at build time.

## Layout

```
<area>/<topic>/
    README.md           # source of truth: annotated list in the grammar below
    reading-guide.html  # GENERATED from README.md by bin/gen-guide.py
    fetch.sh            # GENERATED; downloads the open PDFs into ./pdfs/ (git-ignored)
bin/
    gen-guide.py        # README.md -> reading-guide.html + fetch.sh
    render.sh           # reading-guide.html -> PDF (headless Chrome; inlines the CSS)
lib/
    guide.css           # shared print house style
Makefile                # `make` renders all guides; `make fetch` runs all fetchers
```

Areas are top-level dirs (`machine-learning/`, `computer-architecture/`, `compilers/`,
`programming-languages/`). A topic is a directory under an area. Two kinds:
- **Subtopics** (e.g. `compilers/register-allocation-and-scheduling/`) hold the
  canonical, in-depth list for that theme — where a paper's entry *lives*.
- **`<area>/landmark-papers/`** — a cross-cutting **survey**: the standouts across the
  whole area, each pointing back to its subtopic. It does not replace the subtopics.

## Build / preview

```sh
bin/gen-guide.py <area>/<topic>          # regenerate one guide's HTML + fetch.sh from its README
make                                     # render every reading-guide.html -> .pdf
make <area>/<topic>/reading-guide.pdf    # render just one
make fetch                               # run every topic's fetch.sh
```

`bin/render.sh` needs headless **Chrome/Chromium** + **python3**. (On this setup the
build VM has no HTML→PDF engine; render on a machine that has Chrome.)

## README grammar

The generator (`bin/gen-guide.py`) renders this Markdown, which also reads well on
GitHub. See `compilers/verified-compilation/README.md` for a complete worked example.

```
# Title

Intro paragraph → the .sub line. State the reading path here.

> **Lead-in.** A callout box (how-to-read, or a key distinction). Optional.

### Section title
*one-line italic rationale for why this section is here*
1. **Paper Title** — Authors · Venue Year · 15pp · [DOI](url) · [PDF](url). Why it matters.
   - **Companion** — [Label](url). one-line note.   (indented bullet = nested under the paper)

### Next section
*rationale*
2. **…** — …

## Reference shelf — books
- **FREE** **Book Title** — Author · Year · 320pp · [PDF](url). why it's here.
- **BUY**  **Book Title** — Author · Year · 512pp · [page](url). why it's here.

## Key terms
- **term** — one-line definition.

<!--html-->  …raw HTML emitted verbatim (bespoke boxes: equations, diagrams)…  <!--/html-->
```

Field rules inside a paper/book/companion line:
- `Npp` (e.g. `15pp`) → a page count, shown in the badge and summed into the page tally.
- `[Label](url)` → a link; its kind sets the badge: youtube → VIDEO · `doi.org`/label
  "DOI" → DOI (paywalled) · `*.pdf`/`arxiv.org`/label `pdf|page|arxiv|openai|tr|book` →
  PDF (open) · else WEB. Open PDFs are collected into `fetch.sh`.
- remaining `·`-separated text → authors (first) then venue/date (the `.meta` line).
- the prose after the last link is the "why" sentence. Numbering is automatic and
  continues across sections — just number `1..N` in document order.

## Curation & presentation conventions

- **Verify metadata before listing** — exact title, authors, year, venue. Prefer a
  stable link (DOI `https://doi.org/…` or arXiv).
- **A page count on every paper.** Get it from the real PDF
  (`pdfinfo file.pdf`) or the venue; if unavailable, the Crossref `page` range
  (`https://api.crossref.org/works/<doi>`). Guides show a total page tally.
- **Suggested reading order — pedagogical, not chronological.** Order each list as a
  *path*: group papers into `###` sections, each with a one-line rationale, and state
  the overall path in the intro. Foundations naturally come first, but **do not create
  year/era sections** ("pre-2002" / "modern") — any cutoff is arbitrary.
- **Fill an even number of full pages — papers first.** Guides print double-sided, so
  each should fully fill an even page count (2, 4, …); an odd/short page wastes the
  blank back. Fill primarily by adding *more real papers* (most subtopics have far more
  landmark work than a first pass lists) — never 2–3 papers padded with filler. Once
  the papers are exhausted, top off with genuinely useful material (a key-terms
  glossary, a books shelf, a "how to read this" note). Verify the rendered page count.
- **Be generous with companions / videos / books where they help.** Attach a standout
  explainer article, lecture/talk video, or key textbook chapter to the paper it
  illuminates (nested bullet), and give each area/topic a `## Reference shelf — books`.
  These are reading *guides*, not just lists — but don't force a companion where none
  is worth it.
- **References live in subtopic dirs.** A `landmark-papers/` survey selects the
  standouts and points to each subtopic; it doesn't re-home the canonical entry.

## Finding free copies (search methodology)

Many classics have a legal open PDF even when the publisher's copy is paywalled. For
every paper, try to find one and record it as a `[PDF](url)` alongside the `[DOI]`.

- **Where to look, in order:** the author's own homepage / university page; arXiv; an
  institutional/tech-report repository; a conference's open-access page (USENIX, PMLR,
  NeurIPS/OpenReview, ACM OpenTOC); a course reading page (`*.edu`); the Internet
  Archive (`web.archive.org/…id_/…`) for link-rotted PDFs.
- **Never** link sci-hub, libgen, or other pirated mirrors.
- **Verify every link resolves to the right paper as a PDF** (fetch it; HTTP 200 and
  the bytes start with `%PDF`, not a paywall/abstract/login page). An unverified guess
  is worse than a DOI. `fetch.sh` only downloads the `[PDF]`-labelled links.
- Paywalled with no legal open copy → a `[DOI]` link alone (clearly badged).

## People / voice

Written in the repo owner's voice — plain, complete sentences; explain the *why*, not
just the *what*. When crediting people in prose, first names are fine.
