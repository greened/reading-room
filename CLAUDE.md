# Guide for AI agents (and humans) working in this repo

This repo holds **curated, annotated reading lists** organized by area. The goal:
for each topic, a printable **reading guide** plus a reproducible way to fetch the
underlying papers/books. Keep contributions consistent with the conventions below.

## Golden rules

1. **Never commit third-party PDFs.** Papers and books are copyrighted even when
   free to read. Commit only *our* material (guides, scripts, notes). Everything
   else is referenced by URL and downloaded by a topic's `fetch.sh` into a
   git-ignored `pdfs/` directory.
2. **Rendered guides are build artifacts.** `reading-guide.pdf` is produced by
   `make` and is git-ignored. Never commit it; commit the `.html` source instead.
3. **Reuse the house style.** Guides link the shared stylesheet
   (`lib/guide.css`); do not fork per-guide CSS. `lib/render.sh` inlines it at
   build time.

## Layout

```
<area>/<topic>/
    README.md           # annotated bibliography (browsable on GitHub)
    reading-guide.html  # printable guide; links ../../lib/guide.css
    fetch.sh            # downloads sources into ./pdfs/  (git-ignored)
    sources.tsv         # machine-readable source list
lib/
    guide.css           # shared print house style
    render.sh           # HTML -> PDF (headless Chrome/Chromium; inlines the CSS)
Makefile                # `make` renders all guides; `make fetch` runs all fetchers
```

Areas are top-level directories (e.g. `machine-learning/`, `computer-architecture/`,
`compilers/`, `programming-languages/`). A topic is a directory under an area.

**Two kinds of topic dir:**
- **Topical subtopics** (e.g. `compilers/register-allocation-and-scheduling/`) hold
  the **canonical references** for that subtopic — an annotated `README.md` (and a
  `sources.tsv` once it grows a rendered guide). This is where a paper's entry
  *lives*.
- **`<area>/landmark-papers/`** — a **cross-cutting survey**: the handful of most
  important papers across the whole area, as a rendered guide. It *references* the
  standouts (which live in the subtopic dirs) and points back to each with a
  `→ <subtopic>/` pointer; it does not replace the in-depth subtopic lists. A
  subtopic may also grow its own in-depth `landmark-papers`-style rendered guide.

## Build / preview

```sh
make                     # render every reading-guide.html -> .pdf
make machine-learning/transformers/reading-guide.pdf   # just one
make fetch               # run every topic's fetch.sh
```

`lib/render.sh` needs headless **Chrome/Chromium** and **python3** (used to inline
the stylesheet). No PDF is committed by either step.

## Adding a new topic

1. `mkdir -p <area>/<topic>` (create the area dir if new; add an area `README.md`).
2. Copy an existing topic's `reading-guide.html` as a starting point. Keep the
   `<link rel="stylesheet" href="../../lib/guide.css">` line (adjust `../../` to the
   topic's depth). Do **not** paste CSS inline.
3. Write `README.md` — the same content in Markdown so it renders on GitHub.
4. Write `fetch.sh` — download each source with `curl`, verify each is a real PDF
   (`head -c4` == `%PDF`), write into `./pdfs/`. For book chapters carved from a
   larger PDF, prefer `ghostscript` (`gs -dFirstPage -dLastPage`) with a poppler
   (`pdfseparate`+`pdfunite`) fallback; note any hard-coded page range is
   edition-specific.
5. Write `sources.tsv` (tab-separated) with columns:
   `kind  order  title  authors  year  venue  url  filename  pages`
   where `kind` ∈ {paper, companion, book, video, web}.
6. `make <area>/<topic>/reading-guide.pdf` to verify it renders.
7. Add the topic to the root `README.md` index.

## Reading-guide.html conventions (house style classes)

- Sections use `<h2>`; each is preceded by a `.grouphdr` italic one-liner saying
  *why* the section is where it is.
- The main reading order is `<ol class="papers">`; companion/extra resources for a
  paper go in a nested `<ul class="comp">`.
- Every entry starts with a `.badge`: `b-pdf` (PDF in the fetch set),
  `b-book`, `b-vid` (video), `b-web` (web article), `b-buy` (non-free book). Show a
  page count in the badge where known, e.g. `PDF&middot;15pp`.
- Per-entry `.meta` line: source id, date, venue, and the `.file` filename.
- Equations go in `<div class="eqsec">` with `.eq` (the equation) + `.eqm`
  ("Math:" / "Effect:" lines). Callouts use `.why` / `.notekey`.
- Reading order is **pedagogical, not chronological**; state the ordering logic.
- **Do not create year/era sections** in a landmark list (e.g. "Foundations
  pre-2002" / "Modern"). Any cutoff is arbitrary — just list the papers in a sensible
  reading order (foundations naturally tend to come first).

## Curation & presentation conventions

- **Weight the SELECTION toward what matters to the reader** (recent, seminal, or a
  stated interest) — but present it as one list, per the no-era rule above.
- **References live in subtopic dirs.** A `landmark-papers/` survey selects the
  standouts and points to each with `→ <subtopic>/`; it does not re-home the
  canonical entry.
- **Verify metadata before listing** — exact title, authors, year, venue. Prefer a
  stable URL (DOI `https://doi.org/…` or arXiv).
- **Find free copies beyond the paywall.** Many classics have legal open PDFs on
  authors' homepages, university/department pages, institutional repositories, or
  preprint archives — search those and record a direct `open_pdf` link when one
  reliably resolves. Paywalled entries with no free copy are DOI links (clearly
  marked); `fetch.sh` downloads only the open ones.
- **Fill an even number of pages.** Guides are printed double-sided, so each should
  fully fill an even page count (2, 4, …). If the papers don't fill the last page,
  pad with genuinely useful material — a key-terms glossary, a key-equations cheat
  sheet, a timeline, a "how to read this list" note, or further reading — rather than
  leaving a sparse page.

## People / voice

Written in the repo owner's voice — plain, complete sentences; explain the *why*,
not just the *what*. When crediting people in prose, first names are fine.
