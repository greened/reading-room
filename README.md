# Reading lists

Curated, annotated reading lists for topics I'm studying — organized by area.
Each topic ships a **printable reading guide** (HTML source + rendered PDF), an
annotated bibliography, and a `fetch.sh` that downloads the actual papers/books
so you can reconstruct the reading folder locally.

No third-party PDFs are committed here (papers and books are copyrighted even
when free to read). The repo holds **my own material** — the guides and scripts —
plus **links** and **fetch scripts** to everything else.

## Areas

| Area | Topics |
|------|--------|
| [machine-learning/](machine-learning/) | [transformers](machine-learning/transformers/) |
| [computer-architecture/](computer-architecture/) | *(scaffold)* |
| [compilers/](compilers/) | *(scaffold)* |
| [programming-languages/](programming-languages/) | *(scaffold)* |

## Layout

Each topic directory contains:

- `README.md` — the annotated bibliography (browsable on GitHub)
- `reading-guide.html` — source of the printable guide
- `reading-guide.pdf` — the rendered guide (safe to commit; it's my content)
- `fetch.sh` — downloads every paper/book into `./pdfs/` (git-ignored)
- `sources.tsv` — machine-readable source list (title, authors, year, url, pages…)

## Tooling

- `lib/render.sh <in.html> [out.pdf]` — render a guide to PDF via headless
  Chrome/Chromium (macOS or Linux).
- `lib/guide.css` — the shared print "house style" for the guides.

## Rebuild a topic's reading folder

```sh
cd machine-learning/transformers
./fetch.sh                       # -> ./pdfs/ (papers + free books + d2l ch.11)
../../lib/render.sh reading-guide.html
```
