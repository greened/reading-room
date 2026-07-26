#!/usr/bin/env python3
"""Generate a topic's reading-guide.html (+ fetch.sh) from its README.md.

The README is the single source of truth; the HTML is a faithful render of it, so
the two never drift. Every guide — subtopic list, area survey, or a rich guide like
machine-learning/transformers — uses the one grammar below and the shared house
style (lib/guide.css).

GRAMMAR  (Markdown that also reads well on GitHub)
--------------------------------------------------
    # Title                       → <h1>; first paragraph after it → .sub;
                                     further paragraphs before a section → .lead

    > **Lead-in.** body…          → blockquote whose first line is bold → a .why box

    ## Reading order              → optional wrapper heading (skipped as a header)

    ### Section title             → <h2>; an italic-only line right under it → .grouphdr
    *why this section is here*

    - **Companion** — [Label](url). note.     (a bullet BEFORE any numbered paper in
                                               a section → a "watch/read first" .comp list)

    1. **Title** — Authors · Venue Year · 15pp · [Label](url) · [Label](url). Why.
       - **Companion** — [Label](url). note.   (indented bullet → nested .comp list)

    ## Reference shelf — books    → a .refs list; bullets:
    - **FREE**/**BUY** **Title** — Author (Year) · 320pp · note. [Label](url)

    ## Key terms                  → a .notekey glossary; bullets: - **term** — definition.

    <!--html--> …raw HTML… <!--/html-->    → emitted verbatim, in document order
                                             (bespoke boxes: equations, diagrams — sparingly)

Field rules inside a paper/companion line:
  * `Npp` (e.g. 15pp) → a page count, shown in the badge (PDF·15pp).
  * `[Label](url)` → a link; its kind sets the badge — youtube→VIDEO, doi.org/"DOI"→DOI
    (paywalled), *.pdf|arxiv.org|pdf|page|arxiv|openai|tr|book→PDF (open), else WEB.
  * remaining `·`-separated text → authors (first) then venue/date (.meta line).
  The badge is the entry's best OPEN link if any, else DOI/WEB; the why-sentence is the
  prose after the last link. Open links are collected into fetch.sh.

Usage: lib/gen-guide.py <topic-dir> [<css-relative-path>]
"""
import os, re, sys

d = sys.argv[1].rstrip("/")
css = sys.argv[2] if len(sys.argv) > 2 and not sys.argv[2].startswith("--") else "../../lib/guide.css"
lines = open(os.path.join(d, "README.md"), encoding="utf-8").read().splitlines()

LINK = re.compile(r"\[([^\]]+)\]\((https?://(?:[^()\s]|\([^()\s]*\))*)\)")
PP = re.compile(r"^\s*(\d+)\s*pp\s*$", re.I)
BOLD = re.compile(r"\*\*(.+?)\*\*")


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def inline(s):
    """Render **bold**/*italic* and [links]; escape the rest."""
    out, last = [], 0
    for m in LINK.finditer(s):
        out.append(("t", s[last:m.start()])); out.append(("a", (m.group(1), m.group(2)))); last = m.end()
    out.append(("t", s[last:]))
    r = []
    for kind, val in out:
        if kind == "a":
            r.append(f'<a href="{val[1]}">{esc(val[0])}</a>')
        else:
            t = esc(val)
            t = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", t)
            t = re.sub(r"(?<!\*)\*(?!\s)(.+?)(?<!\s)\*(?!\*)", r"<em>\1</em>", t)
            r.append(t)
    return "".join(r)


def badge_kind(label, url):
    lo, u = label.lower(), url.lower()
    if "youtube.com" in u or "youtu.be" in u:
        return "vid", "VIDEO"
    if "doi.org" in u or lo == "doi":
        return "web", "DOI"
    if u.endswith(".pdf") or "arxiv.org" in u or lo in ("pdf", "page", "arxiv", "openai", "tr", "book"):
        return "pdf", "PDF"
    return "web", "WEB"


def parse_fields(rest):
    """'— Authors · Venue · 15pp · [L](u) · [L](u). Why.' → (authors, venue, pages, anchors, why)."""
    rest = re.sub(r"^\s*[—–-]\s*", "", rest.strip())
    links = list(LINK.finditer(rest))
    if links:
        head, why = rest[:links[-1].end()], rest[links[-1].end():]
    else:
        head, why = rest, ""
    why = re.sub(r"^[\.\s·]+", "", why).strip()
    authors, venue, pages, anchors = "", [], "", []
    for idx, f in enumerate([x.strip() for x in head.split("·")]):
        if not f:
            continue
        if LINK.search(f):                       # pull links out; keep any leftover text
            anchors += [(m.group(1), m.group(2)) for m in LINK.finditer(f)]
            f = LINK.sub("", f).strip(" .·—–-")
            if not f:
                continue
        if PP.match(f):
            pages = PP.match(f).group(1)
        elif idx == 0 and not authors:
            authors = f
        else:
            venue.append(f)
    return authors, " &middot; ".join(esc(v) for v in venue), pages, anchors, why


def primary_badge(anchors, pages, book=False):
    if book:
        kind, txt = "book", "BOOK"
    elif anchors:
        chosen = None
        for l, u in anchors:
            k, t = badge_kind(l, u)
            if k == "pdf":
                chosen = (k, t); break
            chosen = chosen or (k, t)
        kind, txt = chosen
    else:
        kind, txt = "web", "DOI"
    if pages and kind in ("pdf", "web", "book"):
        txt = f"{txt}&middot;{pages}pp"
    return f'<span class="badge b-{kind}">{txt}</span>'


def anchors_html(anchors):
    return " &middot; ".join(f'<a href="{u}">{esc(l)}</a>' for l, u in anchors)


def companion_html(raw):
    """A companion/watch bullet: **Name** — [Label](url). note."""
    bm = BOLD.match(raw.strip())
    name = bm.group(1) if bm else ""
    a, v, p, anchors, why = parse_fields(raw.strip()[bm.end():] if bm else raw)
    if anchors:
        badge = primary_badge(anchors, p)
    elif name.rstrip().endswith("/"):
        badge = '<span class="badge b-web">DIR</span>'   # a "Going deeper" subtopic pointer
    else:
        badge = '<span class="badge b-web">WEB</span>'
    extra = f" {inline(why)}" if why else ""
    tail = f' {anchors_html(anchors)}' if anchors else ""
    return f'<li>{badge}<b>{esc(name)}</b>{(" &mdash; " + inline(a)) if a else ""}{extra}{tail}</li>'


# ---- parse -----------------------------------------------------------------
title, sub, lead, callouts = "Reading list", "", [], []
blocks = []                       # ordered: ('section',dict) | ('books',list) | ('terms',list) | ('raw',str)
books, terms = [], []
cur = None
pdfs = []
mode = "intro"
i, n = 0, len(lines)

for j in range(n):
    m = re.match(r"#\s+(.+)$", lines[j])
    if m:
        title = m.group(1).strip(); i = j + 1; break


def open_section(head, rationale=""):
    global cur
    cur = {"head": head, "rationale": rationale, "watch": [], "papers": []}
    blocks.append(("section", cur))
    return cur


while i < n:
    line = lines[i]; s = line.strip()
    indent = len(line) - len(line.lstrip())

    if s == "<!--html-->":
        buf = []; i += 1
        while i < n and lines[i].strip() != "<!--/html-->":
            buf.append(lines[i]); i += 1
        blocks.append(("raw", "\n".join(buf))); i += 1; continue

    m2 = re.match(r"##\s+(.+)$", line)
    m3 = re.match(r"###\s+(.+)$", line)
    if m3:
        rationale = ""
        if i + 1 < n:
            nx = lines[i + 1].strip()
            if nx.startswith("*") and not nx.startswith("**") and nx.endswith("*"):
                rationale = nx.strip("*").strip(); i += 1
        open_section(m3.group(1).strip(), rationale); mode = "body"; i += 1; continue
    if m2:
        h = m2.group(1).strip(); hl = h.lower()
        if hl.startswith(("reading order", "reading list")):
            mode = "body"; i += 1; continue
        if hl.startswith(("reference shelf", "books")):
            mode = "books"; blocks.append(("books", books)); i += 1; continue
        if hl.startswith(("key terms", "glossary")):
            mode = "terms"; blocks.append(("terms", terms)); i += 1; continue
        open_section(h, ""); mode = "body"; i += 1; continue

    if s.startswith(">"):
        buf = []
        while i < n and lines[i].strip().startswith(">"):
            buf.append(re.sub(r"^\s*>\s?", "", lines[i])); i += 1
        callouts.append(" ".join(x.strip() for x in buf if x.strip())); continue

    bm = re.match(r"\s*-\s+(.*)$", line)   # allow leading indent (nested companions)
    pm = re.match(r"(\d+)\.\s+(.*)$", line)

    if mode == "books" and bm:
        body = bm.group(1); tag = ""
        tm = re.match(r"\*\*(FREE|BUY)\*\*\s+", body)
        if tm:
            tag = tm.group(1); body = body[tm.end():]
        b = BOLD.match(body)
        bt = b.group(1) if b else body
        a, v, p, anchors, why = parse_fields(body[b.end():] if b else body)
        books.append({"tag": tag, "title": bt, "authors": a, "venue": v, "pages": p, "anchors": anchors, "why": why})
        i += 1; continue

    if mode == "terms" and bm:
        b = BOLD.match(bm.group(1))
        if b:
            terms.append((b.group(1), bm.group(1)[b.end():].lstrip(" —–-").rstrip(".")));
        i += 1; continue

    if pm or (bm and BOLD.match((bm.group(1) or ""))):
        raw = pm.group(2) if pm else bm.group(1)
        if bm and indent >= 2 and cur and cur["papers"]:
            cur["papers"][-1]["comps"].append(companion_html(raw)); i += 1; continue
        if bm and indent >= 2 and cur:
            cur["watch"].append(companion_html(raw)); i += 1; continue
        if bm and cur and not cur["papers"] and BOLD.match(raw):
            # top-level bold bullet before papers in a section = watch/companion
            cur["watch"].append(companion_html(raw)); i += 1; continue
        if cur is None:
            open_section("", "")
        b = BOLD.match(raw)
        if not b:
            i += 1; continue
        a, v, p, anchors, why = parse_fields(raw[b.end():])
        cur["papers"].append({"title": b.group(1), "authors": a, "venue": v,
                              "pages": p, "anchors": anchors, "why": why, "comps": []})
        for l, u in anchors:
            if badge_kind(l, u)[0] == "pdf":
                pdfs.append((b.group(1), u))
        i += 1; continue

    if s and mode == "intro":
        para = [s]
        while i + 1 < n and lines[i + 1].strip() and not re.match(r"(#|>|-\s|\d+\.\s|<!--)", lines[i + 1].strip()):
            i += 1; para.append(lines[i].strip())
        txt = " ".join(para)
        if not sub:
            sub = txt
        else:
            lead.append(txt)
        i += 1; continue

    i += 1

# ---- render ----------------------------------------------------------------
npapers = sum(len(b[1]["papers"]) for b in blocks if b[0] == "section")
totpp = sum(int(pp["pages"]) for b in blocks if b[0] == "section" for pp in b[1]["papers"] if pp["pages"])
kinds = set()
for b in blocks:
    if b[0] == "section":
        for pp in b[1]["papers"]:
            for l, u in pp["anchors"]:
                kinds.add(badge_kind(l, u)[0])
legend = []
if "pdf" in kinds:
    legend.append('<span class="badge b-pdf">PDF</span>open copy (see <span class="file">fetch.sh</span>)')
if "web" in kinds:
    legend.append('<span class="badge b-web">DOI</span>publisher link only')
if "vid" in kinds:
    legend.append('<span class="badge b-vid">VIDEO</span>')
tally = f"{npapers} papers"
if totpp:
    tally += f" &middot; &asymp; <b>{totpp} pp</b> of primary reading"
tally += (". &nbsp; Legend: " + " &middot; ".join(legend)) if legend else "."

out = ['<!DOCTYPE html>', '<html lang="en">', '<head>', '<meta charset="utf-8">',
       f'<title>{esc(title)}</title>', f'<link rel="stylesheet" href="{css}">', '</head>', '<body>', '',
       f'<h1>{esc(title)}</h1>']
if sub:
    out.append(f'<p class="sub">{inline(sub)}</p>')
for p in lead:
    out.append(f'<p class="lead">{inline(p)}</p>')
out.append(f'<p class="tally">{tally}</p>')
for c in callouts:
    out.append(f'<div class="why">{inline(c)}</div>')
out.append('')

counter = 0
for kind, payload in blocks:
    if kind == "raw":
        out.append(payload); out.append(''); continue
    if kind == "books":
        if not books:
            continue
        out.append('<h2>Reference shelf &mdash; books</h2>')
        out.append('<p class="grouphdr">The standard texts for the area; free copies linked where a legal one exists.</p>')
        out.append('<ul class="refs">')
        for bk in books:
            badge = primary_badge(bk["anchors"], bk["pages"], book=(bk["tag"] != "BUY"))
            if bk["tag"] == "BUY":
                badge = f'<span class="badge b-buy">BUY{("&middot;" + bk["pages"] + "pp") if bk["pages"] else ""}</span>'
            meta = f' ({bk["venue"]})' if bk["venue"] else ""
            au = f' &mdash; {inline(bk["authors"])}' if bk["authors"] else ""
            why = f' &middot; {inline(bk["why"])}' if bk["why"] else ""
            tail = f' {anchors_html(bk["anchors"])}' if bk["anchors"] else ""
            out.append(f'  <li>{badge}<b>{esc(bk["title"])}</b>{au}{meta}{why}{tail}</li>')
        out.append('</ul>'); out.append(''); continue
    if kind == "terms":
        if not terms:
            continue
        out.append('<h2>Key terms</h2>')
        out.append('<p class="grouphdr">Vocabulary used across this list.</p>')
        defs = " &nbsp; ".join(f'<b>{esc(t)}</b> &mdash; {inline(dfn)}' for t, dfn in terms)
        out.append(f'<div class="notekey">{defs}</div>'); out.append(''); continue

    sec = payload
    if sec["head"]:
        out.append(f'<h2>{inline(sec["head"])}</h2>')
    if sec["rationale"]:
        out.append(f'<p class="grouphdr">{inline(sec["rationale"])}</p>')
    if sec["watch"]:
        out.append('<ul class="comp">')
        out += ["  " + w for w in sec["watch"]]
        out.append('</ul>')
    if sec["papers"]:
        start = counter + 1
        attr = f' start="{start}"' + (f' style="counter-reset:item {counter};"' if counter else "")
        out.append(f'<ol class="papers"{attr}>')
        for p in sec["papers"]:
            counter += 1
            badge = primary_badge(p["anchors"], p["pages"])
            metaline = badge + p["venue"]
            if p["venue"] and p["anchors"]:
                metaline += " &middot; "
            metaline += anchors_html(p["anchors"])
            out.append('  <li>')
            out.append(f'    <span class="title">{inline(p["title"])}</span>' + (f' &mdash; {inline(p["authors"])}' if p["authors"] else ""))
            out.append(f'    <div class="meta">{metaline}</div>')
            if p["why"]:
                out.append(f'    <div class="why-here">{inline(p["why"])}</div>')
            if p["comps"]:
                out.append('    <ul class="comp">')
                out += ["      " + c for c in p["comps"]]
                out.append('    </ul>')
            out.append('  </li>')
        out.append('</ol>')
    out.append('')

out += ['</body>', '</html>', '']
open(os.path.join(d, "reading-guide.html"), "w", encoding="utf-8").write("\n".join(out))

# ---- fetch.sh --------------------------------------------------------------
def slug(t):
    return re.sub(r"[^A-Za-z0-9]+", "-", t)[:48].strip("-") + ".pdf"
fl = ['#!/usr/bin/env bash',
      '# Auto-generated by lib/gen-guide.py. Downloads the open PDFs for this list.',
      'set -uo pipefail', 'cd "$(dirname "$0")"', 'OUT=pdfs; mkdir -p "$OUT"', "UA='Mozilla/5.0'",
      'dl(){ local u="$1" f="$OUT/$2"; if curl -fsSL -A "$UA" -o "$f" "$u" && [ "$(head -c4 "$f")" = "%PDF" ]; then echo "ok   $2"; else echo "FAIL $2"; rm -f "$f"; fi; }']
for t, u in pdfs:
    fl.append(f'dl "{u}" "{slug(t)}"')
fl.append('echo "done -> $OUT/"')
fp = os.path.join(d, "fetch.sh")
open(fp, "w", encoding="utf-8").write("\n".join(fl) + "\n")
os.chmod(fp, 0o755)
print(f"{d}: {npapers} papers ({totpp} pp), {len(pdfs)} open PDFs, {len(books)} books, {len(terms)} terms")
